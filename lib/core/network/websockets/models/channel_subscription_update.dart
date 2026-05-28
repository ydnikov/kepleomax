import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';

class ChannelSubscriptionUpdate {
  const ChannelSubscriptionUpdate({required this.chat});

  factory ChannelSubscriptionUpdate.fromJson(Map<String, dynamic> json) =>
      ChannelSubscriptionUpdate(
        chat: Chat.fromDto(
          ChatDto.fromJson(json['channel'] as Map<String, dynamic>),
          fromCache: false,
        ),
      );

  final Chat chat;
}
