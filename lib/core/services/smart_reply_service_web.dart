import '../models/chat_message.dart';

class SmartReplyService {
  SmartReplyService();

  Future<List<String>> getSuggestions(
      List<ChatMessage> conversationHistory) async {
    // Smart Reply not supported on Web
    return [];
  }

  void dispose() {}
}
