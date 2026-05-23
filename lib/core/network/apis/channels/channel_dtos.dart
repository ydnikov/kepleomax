import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_dtos.g.dart';

@JsonSerializable(createFactory: false)
class ChannelRequestDto {
  ChannelRequestDto({required this.name, required this.imageUrl});

  final String name;
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$ChannelRequestDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class CreateNewChannelResponseDto {
  CreateNewChannelResponseDto({required this.message});

  factory CreateNewChannelResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateNewChannelResponseDtoFromJson(json);

  final String? message;
}
