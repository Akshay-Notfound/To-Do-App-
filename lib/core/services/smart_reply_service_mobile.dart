import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';
import '../models/chat_message.dart'; // Correct import path

class SmartReplyService {
  SmartReply? _smartReply;

  SmartReplyService() {
    try {
      _smartReply = SmartReply();
    } catch (e) {
      print('SmartReply init failed: $e');
    }
  }

  Future<List<String>> getSuggestions(
      List<ChatMessage> conversationHistory) async {
    if (_smartReply == null) return [];

    try {
      // Map ChatMessage to TextMessage
      final history = <TextMessage>[];
      for (var msg in conversationHistory) {
        if (msg.isLocalUser) {
          history.add(TextMessage.createForLocalUser(msg.text, msg.timestamp));
        } else {
          history.add(TextMessage.createForRemoteUser(
              msg.text, msg.timestamp, msg.userId));
        }
      }

      final response = await _smartReply!.suggestReplies(history);
      if (response.status == SmartReplySuggestionResultStatus.success) {
        return response.suggestions;
      }
    } catch (e) {
      print('Smart Reply Error: $e');
    }
    return [];
  }

  void dispose() {
    _smartReply?.close();
  }
}
