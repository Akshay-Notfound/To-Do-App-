import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../../data/templates/exam_templates.dart';
import '../../core/utils/date_parser.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateInputController = TextEditingController();
  DateTime? _selectedDate;
  int _priority = 1; // Default Medium
  String? _selectedSubject;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateInputController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final newTask = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      priority: _priority,
      subjectId: _selectedSubject,
    );

    ref.read(taskListProvider.notifier).addTask(newTask);
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          _dateInputController.clear();
        });
      }
    }
  }

  void _parseNaturalLanguageDate(String input) {
    final parsed = DateParser.parse(input);
    if (parsed != null) {
      setState(() {
        _selectedDate = parsed;
      });
    }
  }

  void _showExamTemplateSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Exam Template'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ExamTemplates.availableExams.map((examName) {
              final topicCount = ExamTemplates.getTotalTopicCount(examName);
              return ListTile(
                leading: const Icon(Icons.school),
                title: Text(examName),
                subtitle: Text('$topicCount topics'),
                onTap: () {
                  Navigator.pop(context);
                  _useTemplate(examName);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _useTemplate(String examName) {
    final tasks = ExamTemplates.generateFromTemplate(examName);

    // Add all tasks from template
    for (var task in tasks) {
      ref.read(taskListProvider.notifier).addTask(task);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Added ${tasks.length} tasks from $examName template!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Use Exam Template',
            onPressed: _showExamTemplateSelector,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Start Template Button
            OutlinedButton.icon(
              onPressed: _showExamTemplateSelector,
              icon: const Icon(Icons.flash_on),
              label: const Text('Quick Start with Exam Template'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Natural Language Date Input
            TextField(
              controller: _dateInputController,
              decoration: InputDecoration(
                labelText: 'Due Date (Natural Language)',
                hintText: 'e.g., "tomorrow 5pm", "next Friday"',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.chat),
                suffixIcon: _selectedDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                            _dateInputController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: _parseNaturalLanguageDate,
            ),

            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '✓ Parsed: ${DateFormat('EEE, MMM d, h:mm a').format(_selectedDate!)}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // Examples
            Wrap(
              spacing: 8,
              children: DateParser.examples.map((example) {
                return ActionChip(
                  label: Text(example, style: const TextStyle(fontSize: 12)),
                  onPressed: () {
                    _dateInputController.text = example;
                    _parseNaturalLanguageDate(example);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // OR divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      Text('OR', style: Theme.of(context).textTheme.bodySmall),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 16),

            // Traditional Date Picker
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Pick Date & Time'
                    : DateFormat('MMM d, h:mm a').format(_selectedDate!),
              ),
            ),

            const SizedBox(height: 16),

            // Priority & Subject Row
            Row(
              children: [
                // Priority
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.green, size: 16),
                            SizedBox(width: 8),
                            Text('Low'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.orange, size: 16),
                            SizedBox(width: 8),
                            Text('Medium'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.circle, color: Colors.red, size: 16),
                            SizedBox(width: 8),
                            Text('High'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _priority = value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Subject
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Optional'),
                    items: const [
                      DropdownMenuItem(
                          value: 'physics', child: Text('Physics')),
                      DropdownMenuItem(
                          value: 'chemistry', child: Text('Chemistry')),
                      DropdownMenuItem(
                          value: 'mathematics', child: Text('Mathematics')),
                      DropdownMenuItem(
                          value: 'biology', child: Text('Biology')),
                      DropdownMenuItem(
                          value: 'history', child: Text('History')),
                      DropdownMenuItem(
                          value: 'geography', child: Text('Geography')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedSubject = value);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Save Button
            FilledButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.check),
              label: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
