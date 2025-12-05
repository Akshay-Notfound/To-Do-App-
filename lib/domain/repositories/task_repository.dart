import '../../data/models/task_model.dart';

abstract class TaskRepository {
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  List<TaskModel> getTasks();
  Future<void> toggleTaskCompletion(String taskId);
}
