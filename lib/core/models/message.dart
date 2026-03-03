import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/call_model.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';

part 'message.freezed.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required int id,
    required int chatId,
    required int senderId,
    required bool isCurrentUser,
    required String message,
    required MessageType type,
    required bool fromCache,
    required bool isRead,
    required DateTime createdAt,
    required DateTime? editedAt,
    CallModel? callData,
  }) = _Message;

  factory Message.loading() => Message(
    id: -10,
    senderId: -1,
    isCurrentUser: false,
    fromCache: false,
    message: '-----------------------------------------------',
    type: MessageType.loading,
    chatId: -1,
    isRead: true,
    createdAt: DateTime(10000),
    editedAt: null,
  );

  factory Message.fromDto(MessageDto dto) {
    final type = messageTypeFromString(dto.type);
    return Message(
      id: dto.id,
      chatId: dto.chatId,
      senderId: dto.senderId,
      isCurrentUser: dto.isCurrentUser,
      message: dto.message,
      type: type,
      fromCache: dto.fromCache,
      isRead: dto.isRead,
      createdAt: DateTime.fromMillisecondsSinceEpoch(dto.createdAt),
      editedAt: dto.editedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(dto.editedAt!),
      callData: type == MessageType.call
          ? CallModel.fromJson(jsonDecode(dto.message) as Map<String, dynamic>)
          : null,
    );
  }

  /// TODO make it better
  /// used to display line in the ui
  factory Message.unreadMessages() => Message(
    id: -11,
    senderId: -1,
    fromCache: false,
    // TODO true or false to work properly?
    isCurrentUser: false,
    message: '',
    type: MessageType.unreadMessages,
    chatId: -1,
    // should be true so counter of unread messages works properly
    isRead: true,
    createdAt: DateTime(10000),
    editedAt: null,
  );

  factory Message.date(DateTime dateTime) => Message(
    id: -12,
    senderId: -1,
    fromCache: false,
    isCurrentUser: false,
    message: '',
    type: MessageType.date,
    chatId: -1,
    // should be true so counter of unread messages works properly
    isRead: true,
    createdAt: dateTime,
    editedAt: null,
  );

  const Message._();

  bool get isSystem => [
    MessageType.loading,
    MessageType.unreadMessages,
    MessageType.date,
  ].contains(type);

  MessageDto toDto() => MessageDto(
    id: id,
    chatId: chatId,
    senderId: senderId,
    isCurrentUser: isCurrentUser,
    //user: user.toDto(),
    //otherUserId: null,
    type: messageTypeToString(type),
    message: message,
    isRead: isRead,
    createdAt: createdAt.millisecondsSinceEpoch,
    editedAt: editedAt?.millisecondsSinceEpoch,
    fromCache: fromCache,
  );
}

enum MessageType { loading, unreadMessages, date, message, call, unknown }

MessageType messageTypeFromString(String value) {
  switch (value) {
    case 'loading':
      return MessageType.loading;
    case 'unread_messages':
      return MessageType.unreadMessages;
    case 'date':
      return MessageType.date;
    case 'message':
      return MessageType.message;
    case 'call':
      return MessageType.call;
    default:
      return MessageType.unknown;
  }
}

String messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.loading:
      return 'loading';
    case MessageType.unreadMessages:
      return 'unread_messages';
    case MessageType.date:
      return 'date';
    case MessageType.message:
      return 'message';
    case MessageType.call:
      return 'call';
    default:
      return 'unknown';
  }
}
