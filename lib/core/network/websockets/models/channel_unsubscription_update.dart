class ChannelUnsubscriptionUpdate {
  const ChannelUnsubscriptionUpdate({required this.channelId, required this.subsCount});

  factory ChannelUnsubscriptionUpdate.fromJson(Map<String, dynamic> json) =>
      ChannelUnsubscriptionUpdate(
        channelId: json['channel_id'] as int,
        subsCount: json['subs_count'] as int,
      );

  final int channelId;
  final int subsCount;
}
