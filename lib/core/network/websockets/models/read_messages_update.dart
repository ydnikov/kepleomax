class ReadMessagesUpdate {
  const ReadMessagesUpdate({
    required this.chatId,
    required this.messagesIds,
    required this.byCurrentUser,
  });

  factory ReadMessagesUpdate.fromJson(Map<String, dynamic> json) =>
      ReadMessagesUpdate(
        chatId: json['chat_id'] as int,
        messagesIds: (json['messages_ids'] as List<dynamic>).cast<int>().toList(),
        byCurrentUser: json['by_current_user'] as bool?
      );

  final int chatId;
  final List<int> messagesIds;
  final bool? byCurrentUser;
}
