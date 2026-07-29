import 'dart:convert';

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
    required this.createdAt,
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
    channelData: json['is_channel'] == true ? ChannelDataDto.fromJson(json) : null,
    unreadCount: (json['unread_count'] as num? ?? 0).toInt(),
    createdAt: json['created_at'] as int,
  );

  /// json['other_user'] should be map\<String, dynamic>
  factory ChatDto.fromLocalJson(Map<String, dynamic> json) {
    // print('KlmLog ChatDto.fromLocalJson, created_at: ${json['chat_created_at']}');

    return ChatDto(
      id: json['chat_id'] as int,
      otherUser: UserDto.fromJson(
        json.map((k, v) => MapEntry(k.replaceAll('user_', ''), v)),
      ),
      lastMessage: json['msg_id'] == null
          ? null
          : MessageDto.fromJson(json.map((k, v) => MapEntry(k.replaceAll('msg_', ''), v)), fromCache: true),
      unreadCount: json['chat_unread_count'] as int,
      channelData: json['chat_channel_data'] == null
          ? null
          : ChannelDataDto.fromJson(
              jsonDecode(json['chat_channel_data'] as String) as Map<String, dynamic>,
            ),
      draft: json['draft_message'] == null
          ? null
          : MessageDraft(
              message: json['draft_message'] as String,
              chatId: json['chat_id'] as int,
              createdAt: json['draft_created_at'] as int,
            ),
      createdAt: json['chat_created_at'] as int,
    );
  }

  ChatDto copyWithNewDraft(MessageDraft? draft) => ChatDto(
    id: id,
    otherUser: otherUser,
    lastMessage: lastMessage,
    unreadCount: unreadCount,
    channelData: channelData,
    createdAt: createdAt,
    draft: draft,
  );

  final int id;
  final UserDto otherUser;
  final MessageDto? lastMessage;
  final int unreadCount;
  final int createdAt;
  final MessageDraft? draft;
  final ChannelDataDto? channelData;

  Map<String, dynamic> toLocalJson() => {
    'id': id,
    'other_user_id': otherUser.id,
    'unread_count': unreadCount,
    'created_at': createdAt,
    'channel_data': channelData == null ? null : jsonEncode(channelData!.toJson()),
  };

  @override
  List<Object?> get props => [id, otherUser, lastMessage, unreadCount];
}

@JsonSerializable()
class ChannelDataDto {
  const ChannelDataDto({
    required this.id,
    required this.channelName,
    required this.description,
    required this.image,
    required this.isOfficial,
    required this.userChannelRole,
    required this.tag,
    required this.subsCount,
  });

  factory ChannelDataDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelDataDtoToJson(this);

  final int id;
  @JsonKey(name: 'channel_name')
  final String channelName;
  final String description;
  final String? image;
  @JsonKey(name: 'is_official')
  final bool isOfficial;
  @JsonKey(name: 'role')
  final UserChannelRoleDto userChannelRole;
  final String tag;
  @JsonKey(name: 'subs_count')
  final int subsCount;
}

@JsonEnum()
enum UserChannelRoleDto {
  owner,
  subscriber,
  none,
  @JsonValue('keep_current')
  keepCurrent,
}
