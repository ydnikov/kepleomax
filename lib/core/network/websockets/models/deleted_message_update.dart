import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';

class DeletedMessageUpdate {
  const DeletedMessageUpdate({
    required this.chatId,
    required this.deletedMessage,
    required this.newLastMessage,
    this.deleteChat = false,
    this.forceNewLastMessage = false,
  });

  factory DeletedMessageUpdate.fromJson(Map<String, dynamic> json) =>
      DeletedMessageUpdate(
        chatId: json['chat_id'] as int,
        deletedMessage: MessageDto.fromJson(json['message'] as Map<String, dynamic>),
        newLastMessage: json['new_last_message'] == null
            ? null
            : MessageDto.fromJson(json['new_last_message'] as Map<String, dynamic>),
        deleteChat: json['delete_chat'] as bool? ?? false,
        forceNewLastMessage: json['force_new_last_message'] as bool? ?? false,
      );

  final int chatId;
  final MessageDto deletedMessage;
  final MessageDto? newLastMessage;
  final bool deleteChat;

  /// when true, newLastMessage will be set to lastMessage even if it's null
  /// when false, if newLastMessage is null, that means there is no need to update
  final bool forceNewLastMessage;
}
