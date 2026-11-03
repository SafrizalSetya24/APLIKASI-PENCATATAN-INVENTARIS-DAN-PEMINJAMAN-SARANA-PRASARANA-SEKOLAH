enum ChatSender {
  user,
  bot,
}

class ChatMessage {
  final String id;
  final ChatSender sender;
  final String text;
  final DateTime timestamp;
  final List<String>? actionPrompts;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.actionPrompts,
  });
}

