import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fpdart/fpdart.dart';

import '../../features/medication/domain/entities/intake_status.dart';
import '../../features/medication/domain/failures/intake_failure.dart';
import '../../features/medication/domain/usecases/cancel_reminder.dart';
import '../../features/medication/domain/usecases/mark_intake_task.dart';
import '../../features/medication/domain/usecases/reschedule_on_snooze.dart';
import '../di/app_bootstrap.dart';
import '../di/injection_container.dart' as di;
import 'logger_service.dart';
import 'notification_service.dart';

/// Applies the Taken / Snooze actions from medication reminders.
///
/// Hive must not be opened by two isolates at once, so while the app is
/// running every action is forwarded to the main isolate and applied there.
/// The background isolate only touches storage itself when the app is not
/// running.
class NotificationActionHandler {
  NotificationActionHandler._();

  static const String actionTaken = 'action_taken';
  static const String actionSnooze = 'action_snooze';
  static const int snoozeMinutes = 15;

  static const String _mainIsolatePortName = 'glucocare.notification_actions';
  static ReceivePort? _mainIsolatePort;

  /// Lets the background isolate hand actions to the running app.
  /// Call once from the main isolate after [bootstrapApp].
  static void listenInMainIsolate() {
    if (_mainIsolatePort != null) return;

    final port = ReceivePort();
    IsolateNameServer.removePortNameMapping(_mainIsolatePortName);
    IsolateNameServer.registerPortWithName(port.sendPort, _mainIsolatePortName);
    port.listen((message) {
      if (message is Map) {
        handleAction(
          actionId: message['actionId'] as String?,
          taskId: message['taskId'] as String?,
        );
      }
    });
    _mainIsolatePort = port;

    // Once the engine detaches the port is dead; stop advertising it so the
    // background isolate falls back to handling actions itself.
    AppLifecycleListener(
      onDetach: () =>
          IsolateNameServer.removePortNameMapping(_mainIsolatePortName),
    );
  }

  /// Entry point for actions tapped while no UI is shown (Android).
  @pragma('vm:entry-point')
  static Future<void> onBackgroundResponse(NotificationResponse response) async {
    final mainPort = IsolateNameServer.lookupPortByName(_mainIsolatePortName);
    if (mainPort != null) {
      mainPort.send(<String, String?>{
        'actionId': response.actionId,
        'taskId': response.payload,
      });
      return;
    }

    try {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
      await bootstrapApp();
      NotificationService.initializeTimeZones();
    } catch (error, stack) {
      // Firebase may be unavailable here, so Crashlytics can't be relied on.
      developer.log(
        'Background notification bootstrap failed',
        name: 'ERROR',
        error: error,
        stackTrace: stack,
      );
      return;
    }

    await handleAction(actionId: response.actionId, taskId: response.payload);
  }

  /// Marks the dose [taskId] as taken, or snoozes it, according to
  /// [actionId]. Taps on the notification body (no action) are ignored.
  static Future<void> handleAction({
    required String? actionId,
    required String? taskId,
  }) async {
    if (taskId == null) return;
    if (actionId != actionTaken && actionId != actionSnooze) return;

    final logger = di.sl<LoggerService>();
    final cancelReminders = di.sl<CancelReminderUseCase>();
    try {
      final Either<IntakeFailure, Unit> result;
      if (actionId == actionTaken) {
        result = await di.sl<MarkIntakeTaskUseCase>()(
          MarkIntakeTaskParams(
            taskId: taskId,
            status: IntakeStatus.taken,
            takenAt: DateTime.now(),
          ),
        );
        // Only once recorded: if saving failed, the reminders keep firing.
        if (result.isRight()) await cancelReminders(taskId);
      } else {
        // Cancel first (the original reminder and its 10/20/30-minute
        // repeats): the snooze reminder reuses the same notification id.
        await cancelReminders(taskId);
        result = await di.sl<RescheduleOnSnoozeUseCase>()(
          RescheduleOnSnoozeParams(taskId: taskId, minutes: snoozeMinutes),
        );
      }

      result.fold(
        (failure) => logger.e(
          'Notification action "$actionId" failed: ${failure.message}',
          failure,
        ),
        (_) => logger.i('Notification action "$actionId" applied'),
      );
    } catch (error, stack) {
      logger.e('Notification action "$actionId" threw', error, stack);
    }
  }
}
