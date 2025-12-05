class ChatMessage {
  final String text;
  final int timestamp;
  final String userId;
  final bool isLocalUser;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.userId,
    required this.isLocalUser,
  });
}
