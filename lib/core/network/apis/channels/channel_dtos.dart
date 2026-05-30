import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';

part 'channel_dtos.g.dart';

@JsonSerializable(createFactory: false)
class ChannelRequestDto {
  const ChannelRequestDto({
    required this.name,
    required this.image,
    required this.description,
    required this.tag,
  });

  final String name;
  @JsonKey(name: 'image')
  final String? image;
  final String description;
  final String tag;

  Map<String, dynamic> toJson() => _$ChannelRequestDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class CreateNewChannelResponseDto {
  const CreateNewChannelResponseDto({required this.data, required this.message});

  factory CreateNewChannelResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateNewChannelResponseDtoFromJson(json);

  final ChatChannelDataDto? data;
  final String? message;
}

@JsonSerializable(createToJson: false)
class GetSubscribersCountResponseDto {
  const GetSubscribersCountResponseDto({required this.count, required this.message});

  factory GetSubscribersCountResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetSubscribersCountResponseDtoFromJson(json);

  final int? count;
  final String? message;
}

@JsonSerializable(createToJson: false)
class GetSubscribersResponseDto {
  GetSubscribersResponseDto({required this.data, required this.message});

  factory GetSubscribersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetSubscribersResponseDtoFromJson(json);

  final List<UserDto>? data;
  final String? message;
}
