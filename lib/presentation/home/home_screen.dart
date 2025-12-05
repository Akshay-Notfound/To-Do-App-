import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/task_provider.dart';
import '../providers/subject_mastery_provider.dart';
import '../tasks/add_task_screen.dart';
import '../chat/study_buddy_screen.dart';
import '../focus/pomodoro_timer_screen.dart';
import '../widgets/ai_widgets.dart';
import '../../core/services/smart_scheduling_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showRescheduleSheet(BuildContext context, WidgetRef ref, List tasks) {
    showModalBottomSheet(
      context: context,
      builder: (context) => RescheduleBottomSheet(
        onReschedule: () {
          // TODO: Implement actual rescheduling logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tasks rescheduled!')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final subjects = ref.watch(subjectMasteryListProvider);
    final weakAreas = subjects.where((s) => s.isWeakArea).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo+'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            tooltip: 'Pomodoro Timer',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PomodoroTimerScreen()),
              );
            },
          ),
          if (tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.auto_fix_high),
              tooltip: 'Smart Reschedule',
              onPressed: () => _showRescheduleSheet(context, ref, tasks),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                WeakAreasCard(weakAreas: weakAreas),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  HapticFeedback.heavyImpact();
                                  ref
                                      .read(taskListProvider.notifier)
                                      .deleteTask(task.id);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ],
                          ),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: _getPriorityColor(task.priority)
                                    .withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            color: task.isCompleted
                                ? Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                    color: _getPriorityColor(task.priority),
                                    width: 4,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (value) {
                                    HapticFeedback.mediumImpact();
                                    ref
                                        .read(taskListProvider.notifier)
                                        .toggleCompletion(task.id);
                                  },
                                  shape: const CircleBorder(),
                                ),
                                title: Text(
                                  task.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: task.isCompleted
                                            ? Theme.of(context).disabledColor
                                            : null,
                                      ),
                                ),
                                subtitle: task.dueDate != null
                                    ? Text(
                                        DateFormat('MMM d, h:mm a')
                                            .format(task.dueDate!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: task.dueDate!.isBefore(
                                                          DateTime.now()) &&
                                                      !task.isCompleted
                                                  ? Colors.red
                                                  : null,
                                            ),
                                      )
                                    : null,
                                trailing: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(task.priority),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'chat',
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StudyBuddyScreen()));
            },
            child: const Icon(Icons.chat),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const AddTaskScreen(),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 2:
        return Colors.redAccent;
      case 1:
        return Colors.amber;
      default:
        return Colors.green;
    }
  }
}
