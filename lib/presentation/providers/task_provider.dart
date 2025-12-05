import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';

// Provider for the Hive Box
final taskBoxProvider = Provider<Box<TaskModel>>((ref) {
  return Hive.box<TaskModel>('tasks');
});

// Provider for the Repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = ref.watch(taskBoxProvider);
  return TaskRepositoryImpl(box);
});

// Provider for the Task List (StateNotifier or equivalent)
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<TaskModel>>((ref) {
      final repository = ref.watch(taskRepositoryProvider);
      return TaskListNotifier(repository);
    });

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repository;

  TaskListNotifier(this._repository) : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = _repository.getTasks();
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _repository.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);
    loadTasks();
  }

  Future<void> toggleCompletion(String taskId) async {
    await _repository.toggleTaskCompletion(taskId);
    loadTasks();
  }
}
