import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/call_model.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'message.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class Message with _$Message {
  const factory Message({
    required int id,
    required int chatId,
    required int senderId,
    required MessageUserType userType,
    required String rawMessage,
    required MessageType type,
    required bool fromCache,
    required bool isReadByCurrentUser,
    required DateTime createdAt,
    DateTime? editedAt,
    CallModel? callData,
    @Default(0) int viewsCount,
  }) = _Message;

  const Message._();

  factory Message.fromDto(MessageDto dto) {
    final type = MessageType.fromString(dto.type);
    return Message(
      id: dto.id,
      chatId: dto.chatId,
      senderId: dto.senderId,
      userType: dto.isCurrentUser ? MessageUserType.current : MessageUserType.other,
      rawMessage: dto.message,
      type: type,
      fromCache: dto.fromCache,
      isReadByCurrentUser: dto.isReadByCurrentUser,
      createdAt: DateTime.fromMillisecondsSinceEpoch(dto.createdAt),
      editedAt: dto.editedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(dto.editedAt!),
      callData: type == MessageType.call
          ? CallModel.fromJson(jsonDecode(dto.message) as Map<String, dynamic>)
          : null,
      viewsCount: dto.viewsCount,
    );
  }

  factory Message.loading() => Message(
    id: -10,
    senderId: -1,
    userType: MessageUserType.system,
    fromCache: false,
    rawMessage: BoneMock.words(8),
    type: MessageType.loading,
    chatId: -1,
    isReadByCurrentUser: true,
    createdAt: DateTime(10000),
  );

  factory Message.unreadMessages() => Message(
    id: unreadMessagesId,
    senderId: -1,
    fromCache: false,
    userType: MessageUserType.system,
    rawMessage: '',
    type: MessageType.unreadMessages,
    chatId: -1,
    // should be true so counter of unread messages works properly
    isReadByCurrentUser: true,
    createdAt: DateTime(10000),
  );

  factory Message.date(DateTime dateTime) => Message(
    id: dateId,
    senderId: -1,
    fromCache: false,
    userType: MessageUserType.system,
    rawMessage: '',
    type: MessageType.date,
    chatId: -1,
    // should be true so counter of unread messages works properly
    isReadByCurrentUser: true,
    createdAt: dateTime,
  );

  /// for testing
  static const unreadMessagesId = -11;
  static const dateId = -12;

  bool get isSystem => userType == MessageUserType.system;

  bool get isPost => type.isPost;

  bool get isCurrentUser => userType == MessageUserType.current;

  bool get isRead => isCurrentUser ? viewsCount > 0 : isReadByCurrentUser;

  String get message =>
      callData == null ? rawMessage : callData!.getCallType().userString;

  MessageDto toDto() => MessageDto(
    id: id,
    chatId: chatId,
    senderId: senderId,
    type: type._value,
    message: rawMessage,
    isReadByCurrentUser: isReadByCurrentUser,
    createdAt: createdAt.millisecondsSinceEpoch,
    editedAt: editedAt?.millisecondsSinceEpoch,
    fromCache: fromCache,
    viewsCount: viewsCount,
  );
}

/// system messages are never cached
enum MessageUserType { other, current, system }

enum MessageType {
  loading('loading'),
  unreadMessages('unread_messages'),
  date('date'),
  message('message'),
  post('post'),
  call('call'),
  draft('draft'),
  unknown('unknown');

  const MessageType(this._value);

  factory MessageType.fromString(String value) =>
      MessageType.values.firstWhereOrNull((el) => el._value == value) ??
      MessageType.unknown;

  final String _value;

  bool get isPost => this == post;
}
