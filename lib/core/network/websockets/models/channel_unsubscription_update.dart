class ChannelUnsubscriptionUpdate {
  const ChannelUnsubscriptionUpdate({required this.chatId});

  factory ChannelUnsubscriptionUpdate.fromJson(Map<String, dynamic> json) =>
      ChannelUnsubscriptionUpdate(chatId: json['channel_id'] as int);

  final int chatId;
}
