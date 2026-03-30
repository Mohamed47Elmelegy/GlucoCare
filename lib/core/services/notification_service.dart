import 'dart:io';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../features/medication/domain/entities/intake_task.dart';
import 'notification_action_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = 'medication_reminder_channel';
  static const String channelName = 'Medication Reminders';
  static const String channelDescription =
      'Reminders for taking your medication';

  // Configurable sumary time (21:00)
  static const int summaryHour = 21;
  static const int summaryMinute = 0;

  NotificationService();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    // 1. Android Setup
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification');

    // 2. iOS Setup
    final List<DarwinNotificationCategory> categories = [
      DarwinNotificationCategory(
        'medication_actions',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain(
            'action_taken',
            '✅ Taken',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'action_snooze',
            '⏰ Snooze',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
        ],
      ),
    ];

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          notificationCategories: categories,
        );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification Action: ${response.actionId}');
        // Optional: Local handling if app is already open
      },
      onDidReceiveBackgroundNotificationResponse:
          NotificationActionHandler.onNotificationTapBackground,
    );
  }

  Future<void> scheduleTaskReminder(IntakeTask task) async {
    final now = tz.TZDateTime.now(tz.local);

    // Scheduled time (either original or snoozeUntil)
    DateTime baseDateTime =
        task.snoozeUntil ??
        DateTime(
          task.date.year,
          task.date.month,
          task.date.day,
          task.scheduledTime.hour,
          task.scheduledTime.minute,
        );

    tz.TZDateTime scheduledTZ = tz.TZDateTime.from(baseDateTime, tz.local);

    // If time is in the past, don't schedule old reminders
    if (scheduledTZ.isBefore(now)) {
      log(
        'WARNING: Skipping reminder for task ${task.id} because time $scheduledTZ is in the past.',
      );
      return;
    }

    log('Scheduling reminder for task ${task.id} at $scheduledTZ');

    // 1. First Notification
    await _scheduleInternal(
      id: task.id.hashCode,
      title: 'Medication: ${task.medicationName}',
      body: 'Time to take your ${task.slot.name} dose',
      scheduledDate: scheduledTZ,
      payload: task.id,
    );

    // 2. Repeats (10, 20, 30 mins) if not snoozed (repeats only for original tasks)
    if (task.snoozeUntil == null) {
      for (int i = 1; i <= 3; i++) {
        final repeatTZ = scheduledTZ.add(Duration(minutes: 10 * i));
        await _scheduleInternal(
          id: task.id.hashCode + i,
          title: 'REPEAT: ${task.medicationName}',
          body: 'Persistent reminder: Have you taken your dose?',
          scheduledDate: repeatTZ,
          payload: task.id,
        );
      }
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    final int id = taskId.hashCode;
    await _notificationsPlugin.cancel(id);
    for (int i = 1; i <= 3; i++) {
      await _notificationsPlugin.cancel(id + i);
    }
  }

  Future<void> scheduleDailySummary(int missedCount) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime summaryTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      summaryHour,
      summaryMinute,
    );

    if (summaryTime.isBefore(now)) {
      summaryTime = summaryTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      999, // Static ID for daily summary
      'Daily Summary',
      'You have $missedCount missed doses today',
      summaryTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'summary_channel',
          'Daily Summary',
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleInternal({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('action_taken', '✅ Taken'),
            AndroidNotificationAction('action_snooze', '⏰ Snooze'),
          ],
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(categoryIdentifier: 'medication_actions'),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else if (Platform.isAndroid) {
      final androidUtils = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Request standard notification permission (Android 13+)
      final bool? notificationsGranted = await androidUtils
          ?.requestNotificationsPermission();

      // Request exact alarm permission (Android 14+)
      final bool? exactAlarmsGranted = await androidUtils
          ?.requestExactAlarmsPermission();

      return (notificationsGranted ?? false) && (exactAlarmsGranted ?? true);
    }
    return false;
  }
}
