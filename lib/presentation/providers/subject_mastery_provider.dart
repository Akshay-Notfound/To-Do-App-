import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/subject_mastery.dart';

/// Provider for SubjectMastery box
final subjectMasteryBoxProvider = Provider<Box<SubjectMastery>>((ref) {
  return Hive.box<SubjectMastery>('subject_mastery');
});

/// Provider for subject mastery list
final subjectMasteryListProvider =
    StateNotifierProvider<SubjectMasteryNotifier, List<SubjectMastery>>((ref) {
  final box = ref.watch(subjectMasteryBoxProvider);
  return SubjectMasteryNotifier(box);
});

class SubjectMasteryNotifier extends StateNotifier<List<SubjectMastery>> {
  final Box<SubjectMastery> _box;

  SubjectMasteryNotifier(this._box) : super(_box.values.toList());

  /// Get or create subject mastery for a given subject
  SubjectMastery getOrCreate(String subjectId, String subjectName) {
    final existing = state.firstWhere(
      (s) => s.subjectId == subjectId,
      orElse: () {
        final newSubject = SubjectMastery(
          subjectId: subjectId,
          subjectName: subjectName,
        );
        _box.put(subjectId, newSubject);
        state = [...state, newSubject];
        return newSubject;
      },
    );
    return existing;
  }

  /// Record task completion for a subject
  void recordTaskCompletion({
    required String subjectId,
    required String subjectName,
    required bool onTime,
  }) {
    final subject = getOrCreate(subjectId, subjectName);
    subject.recordCompletion(onTime: onTime);
    _box.put(subjectId, subject);
    state = [...state]; // Trigger rebuild
  }

  /// Record task snooze
  void recordSnooze({
    required String subjectId,
    required String subjectName,
  }) {
    final subject = getOrCreate(subjectId, subjectName);
    subject.recordSnooze();
    _box.put(subjectId, subject);
    state = [...state];
  }

  /// Add study time
  void addStudyTime({
    required String subjectId,
    required String subjectName,
    required int minutes,
  }) {
    final subject = getOrCreate(subjectId, subjectName);
    subject.addStudyTime(minutes);
    _box.put(subjectId, subject);
    state = [...state];
  }

  /// Get weak areas (subjects needing review)
  List<SubjectMastery> getWeakAreas() {
    return state.where((s) => s.isWeakArea).toList()
      ..sort((a, b) => a.confidenceScore.compareTo(b.confidenceScore));
  }

  /// Get strong areas
  List<SubjectMastery> getStrongAreas() {
    return state.where((s) => s.difficultyLevel == 1).toList()
      ..sort((a, b) => b.confidenceScore.compareTo(a.confidenceScore));
  }

  /// Delete a subject
  void deleteSubject(String subjectId) {
    _box.delete(subjectId);
    state = state.where((s) => s.subjectId != subjectId).toList();
  }

  /// Clear all data
  void clearAll() {
    _box.clear();
    state = [];
  }
}
