import '../models/task_model.dart';
import '../models/subject_mastery.dart';

/// Service for AI-powered task management
class SmartSchedulingService {
  /// Reschedule all non-urgent tasks by X days
  List<TaskModel> rescheduleAllTasks({
    required List<TaskModel> tasks,
    required int daysToShift,
    bool onlyIncompleteTasks = true,
  }) {
    final now = DateTime.now();
    final updatedTasks = <TaskModel>[];

    for (final task in tasks) {
      // Skip completed tasks if specified
      if (onlyIncompleteTasks && task.isCompleted) {
        updatedTasks.add(task);
        continue;
      }

      // Skip important/high priority tasks (don't auto-reschedule)
      if (task.isImportant || task.priority == 2) {
        updatedTasks.add(task);
        continue;
      }

      // Shift the due date
      if (task.dueDate != null) {
        final newDueDate = task.dueDate!.add(Duration(days: daysToShift));
        final updatedTask = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          dueDate: newDueDate,
          isCompleted: task.isCompleted,
          priority: task.priority,
          reminderTime: task.reminderTime,
          subjectId: task.subjectId,
          snoozeCount: task.snoozeCount,
          completedAt: task.completedAt,
          isImportant: task.isImportant,
        );
        updatedTasks.add(updatedTask);
      } else {
        updatedTasks.add(task);
      }
    }

    return updatedTasks;
  }

  /// Suggest breaking a task into subtasks based on subject difficulty
  List<String> suggestSubtaskBreakdown({
    required TaskModel task,
    required SubjectMastery? subjectMastery,
  }) {
    // If no subject or strong area, no breakdown needed
    if (subjectMastery == null || !subjectMast ery.isWeakArea) {
      return [];
    }

    // Suggest breaking into smaller chunks for weak areas
    return [
      '${task.title} - Part 1: Theory Review',
      '${task.title} - Part 2: Practice Problems',
      '${task.title} - Part 3: Revision & Notes',
    ];
  }

  /// Calculate if exam deadline is still feasible
  Map<String, dynamic> assessExamFeasibility({
    required DateTime examDate,
    required List<TaskModel> remainingTasks,
    required int dailyStudyHoursAvailable,
  }) {
    final now = DateTime.now();
    final daysRemaining = examDate.difference(now).inDays;

    if (daysRemaining <= 0) {
      return {
        'feasible': false,
        'message': 'Exam date has passed!',
        'daysRemaining': 0,
        'hoursNeeded': 0,
        'hoursAvailable': 0,
      };
    }

    // Estimate hours needed (2 hrs per high priority, 1 hr per medium/low)
    final hoursNeeded = remainingTasks.fold<int>(0, (total, task) {
      if (task.isCompleted) return total;
      return total + (task.priority == 2 ? 2 : 1);
    });

    final totalHoursAvailable = daysRemaining * dailyStudyHoursAvailable;
    final feasible = hoursNeeded <= totalHoursAvailable;

    return {
      'feasible': feasible,
      'message': feasible
          ? 'You\'re on track! 💪'
          : 'Warning: You may need to increase study hours or reduce scope.',
      'daysRemaining': daysRemaining,
      'hoursNeeded': hoursNeeded,
      'hoursAvailable': totalHoursAvailable,
      'utilizationRate': (hoursNeeded / totalHoursAvailable * 100).toInt(),
    };
  }

  /// Detect burnout patterns
  Map<String, dynamic> detectBurnout({
    required List<SubjectMastery> subjects,
    required int recentStudyHours,
    required int recentTasksCompleted,
  }) {
    // Calculate average confidence across all subjects
    final avgConfidence = subjects.isEmpty
        ? 0.5
        : subjects.fold<double>(0, (sum, s) => sum + s.confidenceScore) /
            subjects.length;

    // Burnout indicators:
    // 1. High study hours but low task completion
    // 2. Declining confidence scores
    final completionRate = recentStudyHours > 0
        ? recentTasksCompleted / recentStudyHours
        : 0;

    final isBurntOut = recentStudyHours > 40 && completionRate < 0.5;

    return {
      'burnoutDetected': isBurntOut,
      'averageConfidence': avgConfidence,
      'completionRate': completionRate,
      'suggestion': isBurntOut
          ? 'Consider taking a short break. Quality > Quantity.'
          : 'Keep up the good work!',
    };
  }
}
