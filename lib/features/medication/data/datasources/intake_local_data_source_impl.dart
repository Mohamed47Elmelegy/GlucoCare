import 'package:hive_flutter/hive_flutter.dart';
import '../models/intake_task_model.dart';
import 'intake_local_data_source.dart';

class IntakeLocalDataSourceImpl implements IntakeLocalDataSource {
  final Box<IntakeTaskModel> intakeBox;

  IntakeLocalDataSourceImpl({required this.intakeBox});

  @override
  Future<void> saveIntakeTask(IntakeTaskModel task) async {
    await intakeBox.put(task.id, task);
  }

  @override
  Future<void> saveAllIntakeTasks(List<IntakeTaskModel> tasks) async {
    final Map<String, IntakeTaskModel> taskMap = {
      for (var task in tasks) task.id: task
    };
    await intakeBox.putAll(taskMap);
  }

  @override
  Future<List<IntakeTaskModel>> getIntakeTasksForDate(DateTime date) async {
    final dateString = _formatDate(date);
    return intakeBox.values.where((task) => _formatDate(task.date) == dateString).toList();
  }

  @override
  Future<IntakeTaskModel?> getIntakeTaskById(String taskId) async {
    return intakeBox.get(taskId);
  }

  @override
  Future<void> updateIntakeTask(IntakeTaskModel task) async {
    await intakeBox.put(task.id, task);
  }

  @override
  Future<List<IntakeTaskModel>> getAllIntakeTasks() async {
    return intakeBox.values.toList();
  }

  @override
  Future<void> clearAllTasks() async {
    await intakeBox.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
