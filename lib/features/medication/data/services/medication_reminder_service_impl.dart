import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/medication.dart';
import '../../domain/failures/medication_failure.dart';
import '../../domain/repositories/intake_repository.dart';
import '../../domain/services/reminder_service_interface.dart';
import '../../domain/usecases/get_medication_tasks.dart';

/// Implementation of the ReminderServiceInterface.
/// Strictly follows Clean Architecture and project standards.
class MedicationReminderServiceImpl implements ReminderServiceInterface {
  final NotificationService notificationService;
  final IntakeRepository intakeRepository;
  final GetMedicationTasksUseCase getMedicationTasksUseCase;
  final LoggerService logger;

  MedicationReminderServiceImpl({
    required this.notificationService,
    required this.intakeRepository,
    required this.getMedicationTasksUseCase,
    required this.logger,
  });

  @override
  Future<Either<Failure, void>> scheduleMedicationAlarms(Medication medication) async {
    try {
      logger.i('Scheduling alarms for medication: ${medication.name} (${medication.id})');
      
      // Ensure tasks are generated for today before scheduling
      await intakeRepository.generateDailyTasks(DateTime.now());
      
      // Use the dedicated UseCase for the business logic of filtering tasks
      final result = await getMedicationTasksUseCase(GetMedicationTasksParams(
        date: DateTime.now(),
        medicationId: medication.id,
      ));
      
      return result.fold(
        (failure) {
          logger.e('Failed to get tasks for scheduling: ${failure.message}', failure);
          return left(ReminderFailure('Failed to schedule alarms: ${failure.message}'));
        },
        (tasks) async {
          if (tasks.isEmpty) {
            logger.i('No tasks found/generated for medication ${medication.id}');
          }

          for (final task in tasks) {
            await notificationService.scheduleTaskReminder(task);
            logger.i('Scheduled reminder for task: ${task.id} at ${task.scheduledTime}');
          }
          
          return right(null);
        },
      );
    } catch (e, stack) {
      logger.e('CRASH in scheduleMedicationAlarms: $e', e, stack);
      return left(ReminderFailure('CRASH in scheduling alarms: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelMedicationAlarms(String medicationId) async {
    try {
      logger.i('Canceling alarms for medication: $medicationId');
      
      final result = await getMedicationTasksUseCase(GetMedicationTasksParams(
        date: DateTime.now(),
        medicationId: medicationId,
      ));
      
      return result.fold(
        (failure) {
           logger.e('Failed to get tasks for cancellation: ${failure.message}', failure);
           return left(ReminderFailure('Failed to fetch tasks for cancellation: ${failure.message}'));
        },
        (tasks) async {
          for (final task in tasks) {
            await notificationService.cancelTaskReminder(task.id);
            logger.i('Canceled reminder for task: ${task.id}');
          }
          
          return right(null);
        },
      );
    } catch (e, stack) {
      logger.e('CRASH in cancelMedicationAlarms: $e', e, stack);
      return left(ReminderFailure('CRASH in canceling alarms: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> handleMissedDose(
    String medicationId,
    String reason,
    DateTime? rescheduleTime,
  ) async {
    try {
      logger.i('Handling missed dose for medication: $medicationId, reason: $reason');
      
      // TODO: Implement sophisticated missed dose logic (e.g. updating task status in repo)
      // For now, we return right(null) as per the initial stub but with proper logging.
      
      return right(null);
    } catch (e, stack) {
      logger.e('CRASH in handleMissedDose: $e', e, stack);
      return left(ReminderFailure('CRASH in handling missed dose: $e'));
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      return await notificationService.requestPermissions();
    } catch (e, stack) {
      logger.e('CRASH in requestPermissions: $e', e, stack);
      return false;
    }
  }
}
