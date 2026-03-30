import 'package:fpdart/fpdart.dart';
import '../../domain/entities/intake_status.dart';
import '../../domain/entities/intake_task.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/failures/intake_failure.dart';
import '../../domain/repositories/intake_repository.dart';
import '../datasources/intake_local_data_source.dart';
import '../datasources/intake_remote_data_source.dart';
import '../datasources/medication_local_data_source.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../models/intake_task_model.dart';

class IntakeRepositoryImpl implements IntakeRepository {
  final IntakeLocalDataSource localDataSource;
  final IntakeRemoteDataSource remoteDataSource;
  final MedicationLocalDataSource medicationLocalDataSource;
  final AuthLocalDataSource authLocalDataSource;

  IntakeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.medicationLocalDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> generateDailyTasks(DateTime date) async {
    try {
      final medications = await medicationLocalDataSource.getMedications();
      final existingTasks = await localDataSource.getIntakeTasksForDate(date);
      
      final List<IntakeTaskModel> newTasks = [];
      final dateOnly = DateTime(date.year, date.month, date.day);

      for (var med in medications) {
        if (!med.isActive) continue;
        
        final startDate = DateTime(med.startDate.year, med.startDate.month, med.startDate.day);
        if (dateOnly.isBefore(startDate)) continue;
        
        if (med.durationDays != null) {
          final endDate = startDate.add(Duration(days: med.durationDays!));
          if (dateOnly.isAfter(endDate)) continue;
        }

        for (var slotName in med.mealSlots) {
          final exists = existingTasks.any(
            (t) => t.medicationId == med.id && t.slot == slotName
          );
          if (exists) continue;

          final timeStr = med.customTimes[slotName] ?? 
            (slotName == MealSlot.breakfast.name ? "08:00" : 
             slotName == MealSlot.lunch.name ? "14:00" : "20:00");
          
          final newTask = IntakeTaskModel(
            id: '${med.id}_${dateOnly.millisecondsSinceEpoch}_$slotName',
            medicationId: med.id,
            medicationName: med.name,
            slot: slotName,
            scheduledTime: timeStr,
            date: dateOnly,
            status: IntakeStatus.pending.name,
          );
          newTasks.add(newTask);
        }
      }

      if (newTasks.isNotEmpty) {
        await localDataSource.saveAllIntakeTasks(newTasks);
        
        // Sync new tasks to cloud if user logged in
        final user = await authLocalDataSource.getCachedUser();
        if (user != null) {
          await remoteDataSource.saveAllIntakeTasks(user.id, newTasks);
        }
      }

      final allTasks = await localDataSource.getIntakeTasksForDate(date);
      return Right(allTasks.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(IntakeGenerationFailure(e.toString()));
    }
  }

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> getTasksForDate(DateTime date) async {
    try {
      final tasks = await localDataSource.getIntakeTasksForDate(date);
      return Right(tasks.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(IntakeStorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<IntakeFailure, Unit>> updateTaskStatus(
    String taskId,
    IntakeStatus status, {
    DateTime? takenAt,
    DateTime? snoozeUntil,
  }) async {
    try {
      final taskModel = await localDataSource.getIntakeTaskById(taskId);
      if (taskModel == null) return const Left(IntakeTaskNotFoundFailure());

      final updatedTask = IntakeTaskModel(
        id: taskModel.id,
        medicationId: taskModel.medicationId,
        medicationName: taskModel.medicationName,
        slot: taskModel.slot,
        scheduledTime: taskModel.scheduledTime,
        date: taskModel.date,
        status: status.name,
        takenAt: takenAt ?? taskModel.takenAt,
        snoozeUntil: snoozeUntil ?? taskModel.snoozeUntil,
      );

      await localDataSource.updateIntakeTask(updatedTask);
      
      // Auto-sync for premium feel
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.updateIntakeTask(user.id, updatedTask);
      }

      return const Right(unit);
    } catch (e) {
      return Left(IntakeUpdateFailure(e.toString()));
    }
  }

  @override
  Future<Either<IntakeFailure, Unit>> syncIntakeTasks() async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null) return const Left(IntakeStorageFailure("User not logged in"));

      final localTasks = await localDataSource.getAllIntakeTasks();
      final res = await remoteDataSource.saveAllIntakeTasks(user.id, localTasks);
      
      return res.fold(
        (l) => Left(IntakeUpdateFailure(l.message)),
        (r) => const Right(unit),
      );
    } catch (e) {
      return Left(IntakeStorageFailure(e.toString()));
    }
  }
}
