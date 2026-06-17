class ReadMessagesUpdate {
  const ReadMessagesUpdate({required this.chatId, required this.messagesData});

  factory ReadMessagesUpdate.fromJson(Map<String, dynamic> json) =>
      ReadMessagesUpdate(
        chatId: json['chat_id'] as int,
        messagesData: (json['messages_data'] as List<dynamic>)
            .map<ReadMessageUpdate>((json) => ReadMessageUpdate.fromJson(json as Map<String, dynamic>))
            .toList(),
      );

  final int chatId;
  final List<ReadMessageUpdate> messagesData;

  Iterable<int> get messagesIds => messagesData.map((m) => m.id);
}

class ReadMessageUpdate {
  const ReadMessageUpdate({required this.id, required this.senderId});

  factory ReadMessageUpdate.fromJson(Map<String, dynamic> json) =>
      ReadMessageUpdate(id: json['id'] as int, senderId: json['sender_id'] as int);

  final int id;
  final int senderId;
}
