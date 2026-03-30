import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/intake_status.dart';
import '../../domain/failures/intake_failure.dart';
import '../../domain/repositories/intake_repository.dart';
import '../../../../core/services/notification_service.dart';
import 'package:get_it/get_it.dart';

class RescheduleOnSnoozeUseCase implements UseCase<Either<IntakeFailure, Unit>, RescheduleOnSnoozeParams> {
  final IntakeRepository repository;
  final NotificationService notificationService;

  RescheduleOnSnoozeUseCase(this.repository, this.notificationService);

  @override
  Future<Either<IntakeFailure, Unit>> call(RescheduleOnSnoozeParams params) async {
    final now = DateTime.now();
    final snoozeUntil = now.add(Duration(minutes: params.minutes));

    // 1. Update in repository
    final result = await repository.updateTaskStatus(
      params.taskId,
      IntakeStatus.snoozed,
      snoozeUntil: snoozeUntil,
    );

    return result.fold(
      (failure) => Left(failure),
      (_) async {
        // 2. Fetch the task to get details for rescheduling
        final tasks = await repository.getTasksForDate(now);
        return tasks.fold(
          (failure) => Left(failure),
          (allTasks) async {
            final task = allTasks.firstWhere((t) => t.id == params.taskId);
            // 3. Schedule new notification
            final rescheduledTask = task.copyWith(snoozeUntil: snoozeUntil);
            await notificationService.scheduleTaskReminder(rescheduledTask);
            return const Right(unit);
          },
        );
      },
    );
  }
}

class RescheduleOnSnoozeParams extends Equatable {
  final String taskId;
  final int minutes;

  const RescheduleOnSnoozeParams({
    required this.taskId,
    this.minutes = 15,
  });

  @override
  List<Object?> get props => [taskId, minutes];
}
