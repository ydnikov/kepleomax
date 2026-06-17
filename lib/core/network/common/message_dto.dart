import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.g.dart';

/// TODO rename to MessageResponse
@JsonSerializable(createToJson: false)
class MessageDto {

  MessageDto({required this.message});

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
  final String? message;
}