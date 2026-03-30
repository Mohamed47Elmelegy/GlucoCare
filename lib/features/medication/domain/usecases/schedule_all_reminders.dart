import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';
import '../../../../core/services/notification_service.dart';

class ScheduleAllRemindersUseCase implements UseCase<Either<IntakeFailure, Unit>, NoParams> {
  final IntakeRepository repository;
  final NotificationService notificationService;

  ScheduleAllRemindersUseCase(this.repository, this.notificationService);

  @override
  Future<Either<IntakeFailure, Unit>> call(NoParams params) async {
    final result = await repository.getTasksForDate(DateTime.now());
    
    return result.fold(
      (failure) => Left(failure),
      (tasks) async {
        for (final task in tasks) {
          await notificationService.scheduleTaskReminder(task);
        }
        return const Right(unit);
      },
    );
  }
}
