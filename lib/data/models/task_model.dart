import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  int priority; // 0: Low, 1: Medium, 2: High

  @HiveField(6)
  DateTime? reminderTime;

  @HiveField(7)
  String? subjectId; // Links to SubjectMastery for AI tracking

  @HiveField(8)
  int snoozeCount; // How many times postponed

  @HiveField(9)
  DateTime? completedAt; // When task was completed

  @HiveField(10)
  bool isImportant; // For smart alerts

  TaskModel({
    String? id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
    this.priority = 1,
    this.reminderTime,
    this.subjectId,
    this.snoozeCount = 0,
    this.completedAt,
    this.isImportant = false,
  }) : id = id ?? const Uuid().v4();

  /// Check if task was completed on time
  bool get wasCompletedOnTime {
    if (!isCompleted || completedAt == null || dueDate == null) return false;
    return completedAt!.isBefore(dueDate!) ||
        completedAt!.isAtSameMomentAs(dueDate!);
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (isCompleted || dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }
}
