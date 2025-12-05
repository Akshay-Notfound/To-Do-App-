import 'package:hive/hive.dart';

part 'focus_session.g.dart';

@HiveType(typeId: 4)
class FocusSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  DateTime? endTime;

  @HiveField(3)
  final int plannedMinutes; // 25, 30, 45, etc.

  @HiveField(4)
  int actualMinutes; // How long they actually focused

  @HiveField(5)
  final String? taskId; // Linked task (optional)

  @HiveField(6)
  final String? subjectId; // Subject being studied

  @HiveField(7)
  bool completed; // Did they complete the session?

  FocusSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.plannedMinutes,
    this.actualMinutes = 0,
    this.taskId,
    this.subjectId,
    this.completed = false,
  });

  /// Calculate completion percentage
  double get completionRate {
    if (plannedMinutes == 0) return 0;
    return (actualMinutes / plannedMinutes * 100).clamp(0, 100);
  }

  /// Get duration in readable format
  String get durationString {
    final hours = actualMinutes ~/ 60;
    final mins = actualMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}
