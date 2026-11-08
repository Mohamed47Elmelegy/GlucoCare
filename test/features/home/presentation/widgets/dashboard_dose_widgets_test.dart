import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/services/notification_service.dart';
import 'package:flutter_test_ai/core/theme/app_theme.dart';
import 'package:flutter_test_ai/features/home/presentation/widgets/dashboard_dose_timeline.dart';
import 'package:flutter_test_ai/features/home/presentation/widgets/dashboard_missed_dose_alert.dart';
import 'package:flutter_test_ai/features/home/presentation/widgets/dashboard_next_dose_card.dart';
import 'package:flutter_test_ai/features/home/presentation/widgets/dose_timeline_tile.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_status.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/failures/intake_failure.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/intake_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/cancel_reminder.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/generate_daily_intake_tasks.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_intake_summary.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_today_intake_tasks.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/mark_intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/schedule_all_reminders.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/intake_cubit.dart'
    show IntakeCubit;
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeIntakeRepository implements IntakeRepository {
  List<IntakeTask> tasks = [];

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> generateDailyTasks(DateTime date) async =>
      Right(tasks);

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> getTasksForDate(DateTime date) async =>
      Right(tasks);

  @override
  Future<Either<IntakeFailure, Unit>> updateTaskStatus(
    String taskId,
    IntakeStatus status, {
    DateTime? takenAt,
    DateTime? snoozeUntil,
  }) async {
    tasks = [
      for (final t in tasks)
        t.id == taskId
            ? t.copyWith(status: status, takenAt: takenAt, snoozeUntil: snoozeUntil)
            : t,
    ];
    return const Right(unit);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SilentNotificationService implements NotificationService {
  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> scheduleTaskReminder(IntakeTask task) async {}

  @override
  Future<void> cancelTaskReminder(String taskId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _now = DateTime(2026, 11, 8, 12);

IntakeTask _task(String name, int hour, IntakeStatus status, MealSlot slot) {
  return IntakeTask(
    id: name,
    medicationId: 'med_$name',
    medicationName: name,
    slot: slot,
    scheduledTime: TimeOfDay(hour: hour, minute: 0),
    date: DateTime(2026, 11, 8),
    status: status,
  );
}

void main() {
  late _FakeIntakeRepository repository;
  late IntakeCubit cubit;

  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('ar');
  });

  setUp(() async {
    repository = _FakeIntakeRepository()
      ..tasks = [
        _task('Amaryl', 8, IntakeStatus.pending, MealSlot.breakfast), // missed
        _task('Vitamin D', 10, IntakeStatus.taken, MealSlot.lunch),
        _task('Metformin', 20, IntakeStatus.pending, MealSlot.dinner), // next
      ];
    final notifications = _SilentNotificationService();
    cubit = IntakeCubit(
      generateDailyIntakeTasks: GenerateDailyIntakeTasksUseCase(repository),
      getTodayIntakeTasks: GetTodayIntakeTasksUseCase(repository),
      markIntakeTask: MarkIntakeTaskUseCase(repository),
      getIntakeSummary: GetIntakeSummaryUseCase(repository, clock: () => _now),
      scheduleAllReminders: ScheduleAllRemindersUseCase(repository, notifications),
      cancelReminder: CancelReminderUseCase(notifications),
    );
    await cubit.loadTasks(date: _now);
  });

  tearDown(() => cubit.close());

  Future<void> pumpDashboard(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  DashboardMissedDoseAlert(),
                  DashboardNextDoseCard(),
                  DashboardDoseTimeline(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders real doses under the app theme without layout errors',
      (tester) async {
    await pumpDashboard(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('جرعة فائتة!'), findsOneWidget);
    expect(find.textContaining('Amaryl'), findsWidgets);
    expect(find.byType(DoseTimelineTile), findsNWidgets(3));
  });

  testWidgets('Taken on the next-dose card records the dose', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(find.text('تم التناول').first);
    await tester.pumpAndSettle();

    expect(
      repository.tasks.firstWhere((t) => t.id == 'Metformin').status,
      IntakeStatus.taken,
    );
    expect(find.text('لا توجد جرعات قادمة اليوم'), findsOneWidget);
  });
}
