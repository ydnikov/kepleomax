// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ChannelRequestDtoToJson(ChannelRequestDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': ?instance.image,
      'description': instance.description,
      'tag': instance.tag,
    };

CreateNewChannelResponseDto _$CreateNewChannelResponseDtoFromJson(
  Map<String, dynamic> json,
) => CreateNewChannelResponseDto(
  data: json['data'] == null
      ? null
      : ChatChannelDataDto.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String?,
);

GetSubscribersCountResponseDto _$GetSubscribersCountResponseDtoFromJson(
  Map<String, dynamic> json,
) => GetSubscribersCountResponseDto(
  count: (json['count'] as num?)?.toInt(),
  message: json['message'] as String?,
);

GetSubscribersResponseDto _$GetSubscribersResponseDtoFromJson(
  Map<String, dynamic> json,
) => GetSubscribersResponseDto(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => UserDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['total_count'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  cursor: (json['cursor'] as num?)?.toInt(),
  message: json['message'] as String?,
);
