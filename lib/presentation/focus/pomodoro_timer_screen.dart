import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key});

  @override
  State<PomodoroTimerScreen> createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  Timer? _timer;
  int _remainingSeconds = 25 * 60; // Default 25 minutes
  int _totalSeconds = 25 * 60;
  bool _isRunning = false;
  bool _isBreak = false;
  int _sessionCount = 0;

  // Settings
  int _workMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;
  final int _sessionsBeforeLongBreak = 4;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _completeSession() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    setState(() {
      _isRunning = false;

      if (!_isBreak) {
        // Work session completed
        _sessionCount++;

        // Determine next break type
        if (_sessionCount % _sessionsBeforeLongBreak == 0) {
          _startBreak(_longBreakMinutes);
        } else {
          _startBreak(_shortBreakMinutes);
        }
      } else {
        // Break completed, start new work session
        _startWorkSession();
      }
    });

    _showCompletionDialog();
  }

  void _startWorkSession() {
    setState(() {
      _isBreak = false;
      _totalSeconds = _workMinutes * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _startBreak(int minutes) {
    setState(() {
      _isBreak = true;
      _totalSeconds = minutes * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isBreak ? '🎉 Work Complete!' : '☕ Break Complete!'),
        content: Text(
          _isBreak
              ? 'Great focus! Time for a break.'
              : 'Break over. Ready for another session?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
            },
            child: const Text('Start'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Session counter
            Text(
              'Session ${_sessionCount + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _isBreak ? 'Break Time' : 'Focus Time',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _isBreak ? Colors.green : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),

            // Circular progress
            SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: _CircularProgressPainter(
                  progress: progress,
                  color:
                      _isBreak ? Colors.green : Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  FloatingActionButton.extended(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                if (_isRunning)
                  FloatingActionButton.extended(
                    onPressed: _pauseTimer,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                if (_remainingSeconds != _totalSeconds) ...[
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 40),

            // Quick duration selectors
            Wrap(
              spacing: 12,
              children: [15, 25, 30, 45, 60].map((mins) {
                return FilterChip(
                  label: Text('${mins}m'),
                  selected: _workMinutes == mins && !_isBreak,
                  onSelected: !_isRunning
                      ? (selected) {
                          setState(() {
                            _workMinutes = mins;
                            if (!_isBreak) {
                              _totalSeconds = mins * 60;
                              _remainingSeconds = _totalSeconds;
                            }
                          });
                        }
                      : null,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 6, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
