class TypingActivityUpdate {
  const TypingActivityUpdate({
    required this.chatId,
    required this.isTyping,
    this.userId = -1,
  });

  factory TypingActivityUpdate.fromJson(
    Map<String, dynamic> json, {
    required bool isTyping,
  }) => TypingActivityUpdate(
    chatId: json['chat_id'] as int,
    userId: json['user_id'] as int,
    isTyping: isTyping,
  );

  final int chatId;
  final int userId;
  final bool isTyping;
}
