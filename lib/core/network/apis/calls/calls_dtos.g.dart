// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewCallDto _$NewCallDtoFromJson(Map<String, dynamic> json) => NewCallDto(
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : NewCallResponseData.fromJson(json['data'] as Map<String, dynamic>),
);

NewCallResponseData _$NewCallResponseDataFromJson(Map<String, dynamic> json) =>
    NewCallResponseData(callId: json['call_id'] as String);

CallGetOfferDto _$CallGetOfferDtoFromJson(Map<String, dynamic> json) =>
    CallGetOfferDto(
      data: CallGetOfferData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallGetOfferDtoToJson(CallGetOfferDto instance) =>
    <String, dynamic>{'data': instance.data};

CallGetOfferData _$CallGetOfferDataFromJson(Map<String, dynamic> json) =>
    CallGetOfferData(type: json['type'] as String, sdp: json['sdp'] as String);

Map<String, dynamic> _$CallGetOfferDataToJson(CallGetOfferData instance) =>
    <String, dynamic>{'type': instance.type, 'sdp': instance.sdp};
