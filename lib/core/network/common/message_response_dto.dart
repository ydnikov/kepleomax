import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class MessageResponseDto {
  const MessageResponseDto({required this.message});

  factory MessageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseDtoFromJson(json);

  final String? message;
}
