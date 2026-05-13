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
