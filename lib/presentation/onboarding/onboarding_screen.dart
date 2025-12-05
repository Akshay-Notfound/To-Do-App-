import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _nameController = TextEditingController();
  String? _selectedExam;
  DateTime? _targetDate;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    // Save to Hive
    final box = await Hive.openBox('settings');
    await box.put('userName', _nameController.text);
    await box.put('targetExam', _selectedExam);
    await box.put('targetDate', _targetDate?.toIso8601String());
    await box.put('onboardingComplete', true);

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildWelcomePage(),
                  _buildProfilePage(),
                  _buildGoalPage(),
                ],
              ),
            ),

            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            // Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(),
                  FilledButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            'Welcome to ToDo+',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Your smart study companion for competitive exams',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _FeatureCard(
            icon: Icons.psychology,
            title: 'AI-Powered',
            description: 'Detects weak areas and suggests improvements',
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.timer,
            title: 'Focus Tools',
            description: 'Pomodoro timer and study sessions',
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.auto_fix_high,
            title: 'Smart Scheduling',
            description: 'Natural language input and auto-rescheduling',
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.badge),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            'Set your goal',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 40),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Target Exam',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.school),
            ),
            items: ['JEE', 'GATE CS', 'UPSC', 'NEET', 'Other']
                .map((exam) => DropdownMenuItem(value: exam, child: Text(exam)))
                .toList(),
            onChanged: (value) => setState(() => _selectedExam = value),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              _targetDate != null
                  ? 'Exam Date: ${_targetDate!.day}/${_targetDate!.month}/${_targetDate!.year}'
                  : 'Select Exam Date',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 180)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (date != null) {
                setState(() => _targetDate = date);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
