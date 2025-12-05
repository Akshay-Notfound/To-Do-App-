/// Natural Language Date Parser for ToDo+ app
/// Supports common phrases like:
/// - "tomorrow", "next week", "in 3 days"
/// - "Monday", "next Friday"
/// - "at 3pm", "9:30am"
/// - Combined: "tomorrow at 5pm", "next Monday 10am"
class DateParser {
  static DateTime? parse(String input) {
    if (input.trim().isEmpty) return null;

    final now = DateTime.now();
    final normalized = input.toLowerCase().trim();

    // Extract time if present
    final timeMatch =
        RegExp(r'(\d{1,2}):?(\d{2})?\s*(am|pm)?').firstMatch(normalized);
    int hour = now.hour;
    int minute = now.minute;

    if (timeMatch != null) {
      hour = int.parse(timeMatch.group(1)!);
      minute = timeMatch.group(2) != null ? int.parse(timeMatch.group(2)!) : 0;

      final period = timeMatch.group(3);
      if (period == 'pm' && hour < 12) hour += 12;
      if (period == 'am' && hour == 12) hour = 0;
    }

    DateTime? baseDate;

    // Relative days
    if (normalized.contains('today')) {
      baseDate = DateTime(now.year, now.month, now.day, hour, minute);
    } else if (normalized.contains('tomorrow')) {
      baseDate = DateTime(now.year, now.month, now.day + 1, hour, minute);
    } else if (normalized.contains('day after tomorrow') ||
        normalized.contains('overmorrow')) {
      baseDate = DateTime(now.year, now.month, now.day + 2, hour, minute);
    }

    // "in X days"
    final inDaysMatch = RegExp(r'in\s+(\d+)\s+days?').firstMatch(normalized);
    if (inDaysMatch != null) {
      final days = int.parse(inDaysMatch.group(1)!);
      baseDate = DateTime(now.year, now.month, now.day + days, hour, minute);
    }

    // "next week", "next month"
    if (normalized.contains('next week')) {
      baseDate = DateTime(now.year, now.month, now.day + 7, hour, minute);
    } else if (normalized.contains('next month')) {
      baseDate = DateTime(now.year, now.month + 1, now.day, hour, minute);
    }

    // Weekdays
    final weekdays = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };

    for (var entry in weekdays.entries) {
      if (normalized.contains(entry.key)) {
        final targetWeekday = entry.value;
        int daysToAdd = (targetWeekday - now.weekday + 7) % 7;
        if (daysToAdd == 0 && !normalized.contains('next')) {
          // If it's today, assume they mean next week
          daysToAdd = 7;
        }
        if (normalized.contains('next')) {
          daysToAdd += 7;
        }
        baseDate =
            DateTime(now.year, now.month, now.day + daysToAdd, hour, minute);
        break;
      }
    }

    return baseDate;
  }

  /// Get user-friendly examples
  static List<String> get examples => [
        'tomorrow',
        'tomorrow at 5pm',
        'next Monday',
        'next Friday 10am',
        'in 3 days',
        'Saturday 2:30pm',
      ];
}
