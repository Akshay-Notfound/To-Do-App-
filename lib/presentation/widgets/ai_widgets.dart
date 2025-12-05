import 'package:flutter/material.dart';
import '../../data/models/subject_mastery.dart';

/// Widget to display weak areas requiring review
class WeakAreasCard extends StatelessWidget {
  final List<SubjectMastery> weakAreas;

  const WeakAreasCard({
    super.key,
    required this.weakAreas,
  });

  @override
  Widget build(BuildContext context) {
    if (weakAreas.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.orange.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Topics Needing Review',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...weakAreas.take(3).map((subject) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(subject.confidenceScore),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject.subjectName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              'Confidence: ${(subject.confidenceScore * 100).toInt()}% • ${subject.timesSnoozed} snoozes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 20),
                        onPressed: () {
                          // TODO: Navigate to subject detail
                        },
                      ),
                    ],
                  ),
                )),
            if (weakAreas.length > 3)
              TextButton(
                onPressed: () {
                  // TODO: Show all weak areas
                },
                child: Text('View all ${weakAreas.length} topics'),
              ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.7) return Colors.green;
    if (confidence >= 0.4) return Colors.orange;
    return Colors.red;
  }
}

/// Smart reschedule bottom sheet
class RescheduleBottomSheet extends StatelessWidget {
  final VoidCallback onReschedule;

  const RescheduleBottomSheet({
    super.key,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Smart Reschedule',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Shift non-urgent tasks to give yourself breathing room',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          _RescheduleOption(
            title: 'Shift by 1 day',
            subtitle: 'Postpone low-priority tasks by 24 hours',
            icon: Icons.today,
            onTap: () {
              Navigator.pop(context, 1);
              onReschedule();
            },
          ),
          const SizedBox(height: 12),
          _RescheduleOption(
            title: 'Shift by 2 days',
            subtitle: 'Postpone low-priority tasks by 48 hours',
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.pop(context, 2);
              onReschedule();
            },
          ),
          const SizedBox(height: 12),
          _RescheduleOption(
            title: 'Shift by 1 week',
            subtitle: 'Postpone low-priority tasks by 7 days',
            icon: Icons.event,
            onTap: () {
              Navigator.pop(context, 7);
              onReschedule();
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _RescheduleOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RescheduleOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
