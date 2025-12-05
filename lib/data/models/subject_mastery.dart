import 'package:hive/hive.dart';

part 'subject_mastery.g.dart';

@HiveType(typeId: 3)
class SubjectMastery {
  @HiveField(0)
  final String subjectId; // Unique ID for the subject/topic

  @HiveField(1)
  final String subjectName; // Display name (e.g., "Physics - Thermodynamics")

  @HiveField(2)
  double confidenceScore; // 0.0 to 1.0 (calculated from performance)

  @HiveField(3)
  int tasksCompleted; // Number of tasks finished

  @HiveField(4)
  int tasksFailed; // Tasks not completed by deadline

  @HiveField(5)
  int timesSnoozed; // How many times user postponed tasks

  @HiveField(6)
  DateTime lastRevised; // Last time user worked on this subject

  @HiveField(7)
  int totalStudyMinutes; // Total time spent on this subject

  SubjectMastery({
    required this.subjectId,
    required this.subjectName,
    this.confidenceScore = 0.5, // Start neutral
    this.tasksCompleted = 0,
    this.tasksFailed = 0,
    this.timesSnoozed = 0,
    DateTime? lastRevised,
    this.totalStudyMinutes = 0,
  }) : lastRevised = lastRevised ?? DateTime.now();

  /// Determines if this subject needs review/is a weak area
  bool get isWeakArea {
    // Weak if:
    // - Snoozed more than 2 times
    // - OR confidence score below 0.4
    // - OR failed tasks > completed tasks
    return timesSnoozed > 2 ||
        confidenceScore < 0.4 ||
        (tasksCompleted > 0 && tasksFailed > tasksCompleted);
  }

  /// Get difficulty level: Easy (1), Medium (2), Hard (3)
  int get difficultyLevel {
    if (confidenceScore >= 0.7) return 1; // Easy
    if (confidenceScore >= 0.4) return 2; // Medium
    return 3; // Hard
  }

  /// Recalculate confidence score based on performance
  void recalculateConfidence() {
    if (tasksCompleted == 0 && tasksFailed == 0) {
      confidenceScore = 0.5; // Neutral if no data
      return;
    }

    final totalTasks = tasksCompleted + tasksFailed;
    final completionRate = tasksCompleted / totalTasks;

    // Factor in snoozes (each snooze reduces confidence by 0.05)
    final snoozePenalty = timesSnoozed * 0.05;

    // Calculate final score (max 1.0, min 0.0)
    confidenceScore = (completionRate - snoozePenalty).clamp(0.0, 1.0);
  }

  /// Record a task completion
  void recordCompletion({required bool onTime}) {
    if (onTime) {
      tasksCompleted++;
    } else {
      tasksFailed++;
    }
    lastRevised = DateTime.now();
    recalculateConfidence();
  }

  /// Record a task snooze
  void recordSnooze() {
    timesSnoozed++;
    recalculateConfidence();
  }

  /// Add study time
  void addStudyTime(int minutes) {
    totalStudyMinutes += minutes;
    lastRevised = DateTime.now();
  }

  /// Get user-friendly status message
  String get statusMessage {
    if (isWeakArea) {
      return "⚠️ Needs review - Consider breaking tasks into smaller chunks";
    } else if (difficultyLevel == 1) {
      return "✅ Strong area - Keep it up!";
    } else {
      return "📚 Making progress";
    }
  }

  /// Get color for UI display
  String get statusColor {
    if (isWeakArea) return 'red';
    if (difficultyLevel == 1) return 'green';
    return 'orange';
  }

  /// Copy with method for updates
  SubjectMastery copyWith({
    String? subjectId,
    String? subjectName,
    double? confidenceScore,
    int? tasksCompleted,
    int? tasksFailed,
    int? timesSnoozed,
    DateTime? lastRevised,
    int? totalStudyMinutes,
  }) {
    return SubjectMastery(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      tasksFailed: tasksFailed ?? this.tasksFailed,
      timesSnoozed: timesSnoozed ?? this.timesSnoozed,
      lastRevised: lastRevised ?? this.lastRevised,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
    );
  }
}
