// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ChannelRequestDtoToJson(ChannelRequestDto instance) =>
    <String, dynamic>{'name': instance.name, 'image_url': instance.imageUrl};

CreateNewChannelResponseDto _$CreateNewChannelResponseDtoFromJson(
  Map<String, dynamic> json,
) => CreateNewChannelResponseDto(message: json['message'] as String?);
