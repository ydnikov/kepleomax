import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/auth/auth_controller.dart';

part 'message_dtos.freezed.dart';

part 'message_dtos.g.dart';

@JsonSerializable(createToJson: false)
class MessagesResponse {
  MessagesResponse({required this.data, required this.message});

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseFromJson(json);

  final List<MessageDto>? data;
  final String? message;
}

@Freezed(fromJson: false, toJson: false)
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    required int id,
    required int chatId,
    required int senderId,
    required String message,
    required bool isReadByCurrentUser,
    required int createdAt,
    required int? editedAt,
    required bool fromCache,
    @Default('message') String type,
    @Default(0) int viewsCount
  }) = _MessageDto;

  const MessageDto._();

  factory MessageDto.fromJson(Map<String, dynamic> json, {bool fromCache = false}) =>
      MessageDto(
        id: (json['message_id'] as int?) ?? json['id'] as int,
        chatId: json['chat_id'] as int,
        senderId: json['sender_id'] as int,
        message: json['message'] as String,
        type: json['type'] as String,
        isReadByCurrentUser: json['is_read'] == 1
            ? true
            : json['is_read'] == 0
            ? false
            : json['is_read'] as bool,
        createdAt: json['created_at'] as int,
        editedAt: json['edited_at'] as int?,
        fromCache: fromCache,
        viewsCount: json['views_count'] as int
      );

  factory MessageDto.fromDraft({required String message, required int chatId}) =>
      MessageDto(
        id: chatId,
        chatId: chatId,
        senderId: -1,
        message: message,
        isReadByCurrentUser: true,
        createdAt: 8640000000000000,
        editedAt: null,
        fromCache: true,
      );

  Map<String, dynamic> toLocalJson() => {
    'id': id,
    'chat_id': chatId,
    'sender_id': senderId,
    'is_current_user': isCurrentUser ? 1 : 0,
    'message': message,
    'type': type,
    'is_read': isReadByCurrentUser ? 1 : 0,
    'created_at': createdAt,
    'edited_at': editedAt,
    'views_count': viewsCount,
  };

  bool get isCurrentUser => senderId == AuthController.currentUserId;
}
