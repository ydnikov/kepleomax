import 'package:freezed_annotation/freezed_annotation.dart';

part 'calls_dtos.g.dart';

@JsonSerializable(createToJson: false)
class NewCallDto {
  NewCallDto({required this.message, required this.data});

  factory NewCallDto.fromJson(Map<String, dynamic> json) =>
      _$NewCallDtoFromJson(json);

  final String? message;
  final NewCallResponseData? data;
}

@JsonSerializable(createToJson: false)
class NewCallResponseData {
  NewCallResponseData({required this.callId});

  factory NewCallResponseData.fromJson(Map<String, dynamic> json) =>
      _$NewCallResponseDataFromJson(json);

  @JsonKey(name: 'call_id')
  final String callId;
}

class CallStatusDto {
  CallStatusDto({required this.status});

  factory CallStatusDto.fromJson(Map<String, dynamic> json) {
    final status = json['data']?['status'] as String;
    return CallStatusDto(status: CallStatus.fromString(status));
  }

  CallStatus status;
}

enum CallStatus {
  active,
  pending,
  ended;

  factory CallStatus.fromString(String value) {
    switch (value) {
      case 'active':
        return active;
      case 'pending':
        return pending;
      case 'ended':
        return ended;
      default:
        throw Exception('unsupported CallStatus');
    }
  }
}
