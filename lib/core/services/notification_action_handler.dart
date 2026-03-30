import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../injection_container.dart' as di;
import '../../features/medication/domain/usecases/mark_intake_task.dart';
import '../../features/medication/domain/entities/intake_status.dart';
import '../../features/medication/domain/usecases/reschedule_on_snooze.dart';

class NotificationActionHandler {
  @pragma('vm:entry-point')
  static void onNotificationTapBackground(NotificationResponse response) async {
    log('Background Notification Action: ${response.actionId}');
    
    try {
      // Initialize DI if not already initialized in this isolate
      if (!di.sl.isRegistered<MarkIntakeTaskUseCase>()) {
        await di.init();
      }

      final String? taskId = response.payload;
      if (taskId == null) return;

      if (response.actionId == 'action_taken') {
        final markUseCase = di.sl<MarkIntakeTaskUseCase>();
        await markUseCase(MarkIntakeTaskParams(
          taskId: taskId,
          status: IntakeStatus.taken,
          takenAt: DateTime.now(),
        ));
        log('Task $taskId marked as taken from background');
      } else if (response.actionId == 'action_snooze') {
        final snoozeUseCase = di.sl<RescheduleOnSnoozeUseCase>();
        await snoozeUseCase(RescheduleOnSnoozeParams(
          taskId: taskId,
          minutes: 15,
        ));
        log('Task $taskId snoozed from background');
      }
    } catch (e, stack) {
      log('Error handling background notification: $e');
      // In a real app, log to Crashlytics here:
      // FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }
}
