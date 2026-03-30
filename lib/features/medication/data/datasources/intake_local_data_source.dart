import '../models/intake_task_model.dart';

abstract class IntakeLocalDataSource {
  Future<void> saveIntakeTask(IntakeTaskModel task);
  Future<void> saveAllIntakeTasks(List<IntakeTaskModel> tasks);
  Future<List<IntakeTaskModel>> getIntakeTasksForDate(DateTime date);
  Future<IntakeTaskModel?> getIntakeTaskById(String taskId);
  Future<void> updateIntakeTask(IntakeTaskModel task);
  Future<List<IntakeTaskModel>> getAllIntakeTasks();
  Future<void> clearAllTasks();
}
