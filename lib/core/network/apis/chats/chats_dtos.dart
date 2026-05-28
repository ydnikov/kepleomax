import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/message_draft.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';

part 'chats_dtos.g.dart';

@JsonSerializable(createToJson: false)
class ChatResponse {
  const ChatResponse({required this.data, required this.message});

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  final ChatDto? data;
  final String? message;
}

@JsonSerializable(createToJson: false)
class ChatsResponse {
  const ChatsResponse({required this.data, required this.message});

  factory ChatsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatsResponseFromJson(json);

  final List<ChatDto>? data;
  final String? message;
}

class ChatDto extends Equatable {
  const ChatDto({
    required this.id,
    required this.otherUser,
    required this.lastMessage,
    required this.unreadCount,
    required this.channelData,
    this.draft,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) => ChatDto(
    id: (json['id'] as num).toInt(),
    otherUser: json['other_user'] == null
        ? UserDto.empty()
        : UserDto.fromJson(json['other_user'] as Map<String, dynamic>),
    lastMessage: json['last_message'] == null
        ? null
        : MessageDto.fromJson(json['last_message'] as Map<String, dynamic>),
    channelData: json['is_channel'] == true
        ? ChatChannelDataDto.fromJson(json)
        : null,
    unreadCount: (json['unread_count'] as num? ?? 0).toInt(),
  );

  /// json['other_user'] should be map\<String, dynamic>
  factory ChatDto.fromLocalJson(Map<String, dynamic> json) => ChatDto(
    id: json['id'] as int,
    otherUser: UserDto.fromJson(json),
    lastMessage: json['message_id'] == null
        ? null
        : MessageDto.fromJson(json, fromCache: true),
    unreadCount: json['unread_count'] as int,
    channelData: null,
    draft: json['draft_message'] == null
        ? null
        : MessageDraft(
            message: json['draft_message'] as String,
            chatId: json['id'] as int,
            createdAt: json['draft_created_at'] as int,
          ),
  );

  ChatDto copyWithNewDraft(MessageDraft? draft) => ChatDto(
    id: id,
    otherUser: otherUser,
    lastMessage: lastMessage,
    unreadCount: unreadCount,
    channelData: channelData,
    draft: draft,
  );

  final int id;
  final UserDto otherUser;
  final MessageDto? lastMessage;
  final int unreadCount;
  final MessageDraft? draft;
  final ChatChannelDataDto? channelData;

  Map<String, dynamic> toLocalJson() => {
    'id': id,
    'other_user_id': otherUser.id,
    'unread_count': unreadCount,
  };

  @override
  List<Object?> get props => [id, otherUser, lastMessage, unreadCount];
}

@JsonSerializable(createToJson: false)
class ChatChannelDataDto {
  const ChatChannelDataDto({
    required this.id,
    required this.channelName,
    required this.description,
    required this.imageUrl,
    required this.isOfficial,
    required this.userChannelRole,
    required this.tag,
  });

  factory ChatChannelDataDto.fromJson(Map<String, dynamic> json) =>
      _$ChatChannelDataDtoFromJson(json);

  final int id;
  @JsonKey(name: 'channel_name')
  final String channelName;
  final String description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'is_official')
  final bool isOfficial;
  @JsonKey(name: 'role')
  final UserChannelRoleDto userChannelRole;
  final String tag;
}

@JsonEnum()
enum UserChannelRoleDto {
  owner,
  subscriber,
  none;
}