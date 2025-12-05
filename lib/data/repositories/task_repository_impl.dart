import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<TaskModel> _taskBox;

  TaskRepositoryImpl(this._taskBox);

  @override
  Future<void> addTask(TaskModel task) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
  }

  @override
  List<TaskModel> getTasks() {
    return _taskBox.values.toList();
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await task.save(); // HiveObject extension
    // Or: await _taskBox.put(task.id, task);
  }

  @override
  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await task.save();
    }
  }
}
