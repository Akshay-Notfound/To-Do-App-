import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/models/task_model.dart'; // Added missing import
import 'presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');

  // Initialize Firebase (Skip on Web if no options)
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Firebase Init Error: $e");
    }
  }

  // Initialize Notifications
  if (!kIsWeb) {
    final notificationService = NotificationService();
    await notificationService.init();
  }

  runApp(const ProviderScope(child: ToDoApp()));
}

class ToDoApp extends ConsumerWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ToDo+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
