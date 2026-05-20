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
  CallStatusDto({required this.status, required this.message});

  factory CallStatusDto.fromJson(Map<String, dynamic> json) {
    final status = json['data']?['status'] as String?;
    return CallStatusDto(
      status: status == null ? null : CallStatus.fromString(status),
      message: json['message'] as String?,
    );
  }

  final CallStatus? status;
  final String? message;
}

@JsonSerializable()
class CallGetOfferDto {
  CallGetOfferDto({required this.data});

  factory CallGetOfferDto.fromJson(Map<String, dynamic> json) =>
      _$CallGetOfferDtoFromJson(json);

  final CallGetOfferData data;
}

@JsonSerializable()
class CallGetOfferData {
  CallGetOfferData({required this.type, required this.sdp});

  factory CallGetOfferData.fromJson(Map<String, dynamic> json) =>
      _$CallGetOfferDataFromJson(json);

  final String type;
  final String sdp;
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
