import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  int _priority = 1; // Default Medium

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final newTask = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      priority: _priority,
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _selectedDate == null
                          ? 'Set Due Date'
                          : DateFormat('MMM d, h:mm a').format(_selectedDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: _priority,
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Low')),
                    DropdownMenuItem(value: 1, child: Text('Medium')),
                    DropdownMenuItem(value: 2, child: Text('High')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _priority = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saveTask,
              child: const Padding(
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
