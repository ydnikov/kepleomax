import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dtos.g.dart';
part 'message_dtos.freezed.dart';

@JsonSerializable()
class MessagesResponse {

  MessagesResponse({required this.data, required this.message});

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseFromJson(json);
  final List<MessageDto>? data;
  final String? message;

  Map<String, dynamic> toJson() => _$MessagesResponseToJson(this);
}

@Freezed(fromJson: false, toJson: false)
abstract class MessageDto with _$MessageDto {

  const factory MessageDto({
    required int id,
    required int chatId,
    required int senderId,
    required bool isCurrentUser,
    required String message,
    required bool isRead,
    required int createdAt,
    required int? editedAt,
    required bool fromCache,
    @Default('message') String type,
  }) = _MessageDto;
  const MessageDto._();

  factory MessageDto.fromJson(Map<String, dynamic> json, {bool fromCache = false}) =>
      MessageDto(
        id: json['id'] as int,
        chatId: json['chat_id'] as int,
        senderId: json['sender_id'] as int,
        isCurrentUser: json['is_current_user'] == null && json['user'] == null
            ? throw Exception('is_current_user or user should be provided')
            : json['user']?['is_current'] as bool? ??
                  (json['is_current_user'] == 1
                      ? true
                      : json['is_current_user'] == 0
                      ? false
                      : json['is_current_user'] as bool),
        message: json['message'] as String,
        type: json['type'] as String,
        isRead: json['is_read'] == 1
            ? true
            : json['is_read'] == 0
            ? false
            : json['is_read'] as bool,
        createdAt: json['created_at'] as int,
        editedAt: json['edited_at'] as int?,
        fromCache: fromCache,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'chat_id': chatId,
    'sender_id': senderId,
    'is_current_user': isCurrentUser,
    'message': message,
    'type': type,
    'is_read': isRead,
    'created_at': createdAt,
    'edited_at': editedAt,
  };

  Map<String, dynamic> toLocalJson() => {
    'id': id,
    'chat_id': chatId,
    'sender_id': senderId,
    'is_current_user': isCurrentUser ? 1 : 0,
    'message': message,
    'type': type,
    'is_read': isRead ? 1 : 0,
    'created_at': createdAt,
    'edited_at': editedAt,
  };
}
