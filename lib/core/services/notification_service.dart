import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/medication/domain/entities/medication.dart';
import '../../features/medication/domain/services/reminder_service_interface.dart';

class NotificationService implements ReminderServiceInterface {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

  @override
  Future<void> scheduleMedicationAlarms(Medication medication) async {
    for (int i = 0; i < medication.scheduleTimes.length; i++) {
      final time = medication.scheduleTimes[i];
      final now = DateTime.now();

      // Calculate next occurrence
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _scheduleAlarm(
        id: medication.id.hashCode + i,
        title: 'Medication: ${medication.name}',
        body: 'Time to take ${medication.dosage} ${medication.unit}',
        scheduledDate: scheduledDate,
      );
    }
  }

  @override
  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      return await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? granted = await androidImplementation
          ?.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  @override
  Future<void> cancelMedicationAlarms(String medicationId) async {
    for (int i = 0; i < 10; i++) {
      await _flutterLocalNotificationsPlugin.cancel(medicationId.hashCode + i);
    }
  }

  @override
  Future<void> handleMissedDose(
    String medicationId,
    String reason,
    DateTime? rescheduleTime,
  ) async {
    if (rescheduleTime != null) {
      final newId = medicationId.hashCode + 999;
      await _scheduleAlarm(
        id: newId,
        title: 'Rescheduled Medication',
        body: 'It is time for your rescheduled dose.',
        scheduledDate: rescheduleTime,
      );
    }
  }

  Future<void> _scheduleAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'medication_channel',
          'Medication Reminders',
          channelDescription: 'Reminders for taking medication',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Generic cancel
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
