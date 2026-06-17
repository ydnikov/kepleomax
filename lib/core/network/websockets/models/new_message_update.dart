import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';

class NewMessageUpdate {
  const NewMessageUpdate({required this.message, required this.createdChatInfo});

  factory NewMessageUpdate.fromJson(Map<String, dynamic> json) => NewMessageUpdate(
    message: MessageDto.fromJson(json['message'] as Map<String, dynamic>),
    createdChatInfo: json['created_chat_info'] == null
        ? null
        : CreatedChatInfo.fromJson(
            json['created_chat_info'] as Map<String, dynamic>,
          ),
  );

  final MessageDto message;
  final CreatedChatInfo? createdChatInfo;
}

class CreatedChatInfo {
  const CreatedChatInfo({required this.chatId, required this.usersIds});

  factory CreatedChatInfo.fromJson(Map<String, dynamic> json) => CreatedChatInfo(
    chatId: json['chat_id'] as int,
    usersIds: (json['users_ids'] as List<dynamic>)
        .map<int>((id) => int.parse(id.toString()))
        .toList(),
  );

  final int chatId;
  final Iterable<int> usersIds;
}
