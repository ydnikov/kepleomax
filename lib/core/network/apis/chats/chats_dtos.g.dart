// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
  data: json['data'] == null
      ? null
      : ChatDto.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

ChatsResponse _$ChatsResponseFromJson(Map<String, dynamic> json) =>
    ChatsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

ChatChannelDataDto _$ChatChannelDataDtoFromJson(Map<String, dynamic> json) =>
    ChatChannelDataDto(
      id: (json['id'] as num).toInt(),
      channelName: json['channel_name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      isOfficial: json['is_official'] as bool,
      userChannelRole: $enumDecode(_$UserChannelRoleDtoEnumMap, json['role']),
      tag: json['tag'] as String,
    );

const _$UserChannelRoleDtoEnumMap = {
  UserChannelRoleDto.owner: 'owner',
  UserChannelRoleDto.subscriber: 'subscriber',
  UserChannelRoleDto.none: 'none',
};
