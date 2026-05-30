class ChannelUnsubscriptionUpdate {
  const ChannelUnsubscriptionUpdate({required this.chatId, required this.subsCount});

  factory ChannelUnsubscriptionUpdate.fromJson(Map<String, dynamic> json) =>
      ChannelUnsubscriptionUpdate(
        chatId: json['channel_id'] as int,
        subsCount: json['subs_count'] as int,
      );

  final int chatId;
  final int subsCount;
}
