import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';

part 'get_user_dtos.g.dart';

@JsonSerializable()
class GetUserResponse {

  const GetUserResponse({required this.data, required this.message});

  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserResponseFromJson(json);
  final UserDto? data;
  final String? message;

  Map<String, dynamic> toJson() => _$GetUserResponseToJson(this);
}

@JsonSerializable()
class GetUsersResponse {

  const GetUsersResponse({required this.data, required this.message});

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUsersResponseFromJson(json);
  final List<UserDto> data;
  final String? message;

  Map<String, dynamic> toJson() => _$GetUsersResponseToJson(this);
}