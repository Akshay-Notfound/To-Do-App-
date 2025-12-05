import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'data/models/task_model.dart';
import 'data/models/subject_mastery.dart';
import 'data/models/focus_session.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register all adapters
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(SubjectMasteryAdapter());
  Hive.registerAdapter(FocusSessionAdapter());

  // Open boxes
  await Hive.openBox<TaskModel>('tasks');
  await Hive.openBox<SubjectMastery>('subject_mastery');
  await Hive.openBox<FocusSession>('focus_sessions');
  await Hive.openBox('settings');

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
      home: FutureBuilder(
        future: _checkOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final onboardingComplete = snapshot.data ?? false;

          if (!onboardingComplete) {
            return OnboardingScreen(onComplete: () {
              // Rebuild to show home screen
              (context as Element).markNeedsBuild();
            });
          }

          return const HomeScreen();
        },
      ),
    );
  }

  Future<bool> _checkOnboarding() async {
    final box = await Hive.openBox('settings');
    return box.get('onboardingComplete', defaultValue: false);
  }
}
