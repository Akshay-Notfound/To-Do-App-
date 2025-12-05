import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/chat_message.dart';
import '../../core/services/smart_reply_service.dart';

class StudyBuddyScreen extends ConsumerStatefulWidget {
  const StudyBuddyScreen({super.key});

  @override
  ConsumerState<StudyBuddyScreen> createState() => _StudyBuddyScreenState();
}

class _StudyBuddyScreenState extends ConsumerState<StudyBuddyScreen> {
  final TextEditingController _controller = TextEditingController();
  final SmartReplyService _smartReplyService = SmartReplyService();

  // Conversation History
  final List<ChatMessage> _messages = [];
  List<String> _suggestions = [];

  // Mock "Buddy" ID
  final String _buddyId = 'study_buddy_bot';

  @override
  void dispose() {
    _controller.dispose();
    _smartReplyService.dispose();
    super.dispose();
  }

  void _sendMessage(String text, {bool isLocal = true}) {
    if (text.trim().isEmpty) return;

    setState(() {
      if (isLocal) {
        _messages.add(ChatMessage(
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          userId: 'user',
          isLocalUser: true,
        ));
        _controller.clear();
        _suggestions = []; // Clear old suggestions
      } else {
        _messages.add(ChatMessage(
          text: text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          userId: _buddyId,
          isLocalUser: false,
        ));
      }
    });

    _generateReplies();

    if (isLocal) {
      // Simulate Bot Response after a delay if meaningful
      Future.delayed(const Duration(seconds: 1), () {
        _simulateBotResponse(text);
      });
    }
  }

  void _simulateBotResponse(String userText) {
    String response = "Keep pushing forward! You got this.";
    if (userText.toLowerCase().contains("exam")) {
      response = "Exams are just checking points. Focus on the process!";
    } else if (userText.toLowerCase().contains("tired")) {
      response =
          "Take a short break using the Pomodoro timer, then come back fresh.";
    } else if (userText.toLowerCase().contains("hello")) {
      response = "Hi there! Ready to study?";
    } else if (userText.toLowerCase().contains("thanks")) {
      response = "You're welcome!";
    }

    if (mounted) {
      _sendMessage(response, isLocal: false);
    }
  }

  Future<void> _generateReplies() async {
    if (_messages.isEmpty) return;

    // Only generate suggestions if the last message is from the remote user (the Buddy)
    if (_messages.last.isLocalUser) return;

    final suggestions = await _smartReplyService.getSuggestions(_messages);
    if (mounted) {
      setState(() {
        _suggestions = suggestions;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initial Greeting
    Future.delayed(Duration.zero, () {
      if (mounted) {
        _sendMessage(
          "Hello! I'm your Study Buddy. How are you feeling today?",
          isLocal: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Buddy Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isLocal = message.isLocalUser;
                return Align(
                  alignment:
                      isLocal ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isLocal
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isLocal ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_suggestions.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(_suggestions[index]),
                      onPressed: () {
                        _sendMessage(_suggestions[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (val) => _sendMessage(val),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
