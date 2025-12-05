import '../models/task_model.dart';

/// Pre-built exam templates for quick task creation
class ExamTemplates {
  static Map<String, List<Map<String, dynamic>>> templates = {
    'JEE': [
      {
        'subject': 'Physics',
        'topics': [
          'Mechanics',
          'Thermodynamics',
          'Electromagnetism',
          'Optics',
          'Mod ern Physics'
        ]
      },
      {
        'subject': 'Chemistry',
        'topics': ['Physical', 'Inorganic', 'Organic']
      },
      {
        'subject': 'Mathematics',
        'topics': [
          'Algebra',
          'Calculus',
          'Coordinate Geometry',
          'Trigonometry',
          'Vectors'
        ]
      },
    ],
    'GATE CS': [
      {
        'subject': 'Programming',
        'topics': ['C Programming', 'Data Structures', 'Algorithms']
      },
      {
        'subject': 'Theory',
        'topics': ['TOC', 'Compiler Design', 'OS', 'DBMS', 'CN']
      },
      {
        'subject': 'Aptitude',
        'topics': ['Quantitative', 'Verbal']
      },
    ],
    'UPSC Prelims': [
      {
        'subject': 'History',
        'topics': ['Ancient', 'Medieval', 'Modern']
      },
      {
        'subject': 'Geography',
        'topics': ['Physical', 'Indian', 'World']
      },
      {
        'subject': 'Polity',
        'topics': ['Constitution', 'Acts', 'Amendments']
      },
      {
        'subject': 'Economy',
        'topics': ['Micro', 'Macro', 'Indian Economy']
      },
      {
        'subject': 'Environment',
        'topics': ['Ecology', 'Climate Change']
      },
    ],
    'NEET': [
      {
        'subject': 'Physics',
        'topics': ['Mechanics', 'Optics', 'Modern Physics']
      },
      {
        'subject': 'Chemistry',
        'topics': ['Physical', 'Organic', 'Inorganic']
      },
      {
        'subject': 'Biology',
        'topics': ['Botany', 'Zoology', 'Genetics']
      },
    ],
  };

  /// Generate task list from template
  static List<TaskModel> generateFromTemplate(String examName,
      {DateTime? baseDate}) {
    final template = templates[examName];
    if (template == null) return [];

    final tasks = <TaskModel>[];
    final startDate = baseDate ?? DateTime.now();

    int dayOffset = 1;
    for (var subjectData in template) {
      final subject = subjectData['subject'] as String;
      final topics = subjectData['topics'] as List<String>;

      for (var topic in topics) {
        tasks.add(TaskModel(
          title: '$subject - $topic',
          description: 'Prepare $topic from $subject syllabus',
          dueDate: startDate.add(Duration(days: dayOffset)),
          priority: 1, // Medium by default
          subjectId: subject.toLowerCase().replaceAll(' ', '_'),
        ));
        dayOffset += 2; // Space out tasks
      }
    }

    return tasks;
  }

  /// Get list of available exam names
  static List<String> get availableExams => templates.keys.toList();

  /// Get subject count for an exam
  static int getSubjectCount(String examName) {
    return templates[examName]?.length ?? 0;
  }

  /// Get total topic count for an exam
  static int getTotalTopicCount(String examName) {
    final template = templates[examName];
    if (template == null) return 0;

    return template.fold<int>(
      0,
      (sum, subject) => sum + (subject['topics'] as List).length,
    );
  }
}
