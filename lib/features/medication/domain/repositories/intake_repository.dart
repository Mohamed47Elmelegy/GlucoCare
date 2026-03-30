import 'package:fpdart/fpdart.dart';
import '../entities/intake_task.dart';
import '../entities/intake_status.dart';
import '../failures/intake_failure.dart';

abstract class IntakeRepository {
  /// Generates tasks for a specific date based on active medications.
  /// Should be idempotent.
  Future<Either<IntakeFailure, List<IntakeTask>>> generateDailyTasks(DateTime date);

  /// Retrieves tasks for a specific date.
  Future<Either<IntakeFailure, List<IntakeTask>>> getTasksForDate(DateTime date);

  /// Updates the status of an intake task.
  Future<Either<IntakeFailure, Unit>> updateTaskStatus(
    String taskId,
    IntakeStatus status, {
    DateTime? takenAt,
    DateTime? snoozeUntil,
  });

  /// Syncs local intake tasks with Firebase.
  Future<Either<IntakeFailure, Unit>> syncIntakeTasks();
}
