import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto extends Equatable {

  const UserDto({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.isCurrent,
    required this.isOnline,
    required this.lastActivityTime,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: (json['user_id'] as int?) ?? json['id'] as int,
    username: json['username'] as String,
    profileImage: json['profile_image'] as String?,
    isCurrent: json['is_current'] == 1
        ? true
        : json['is_current'] == 0
        ? false
        : json['is_current'] as bool,
    isOnline: json['is_online'] == 1
        ? true
        : json['is_online'] == 0
        ? false
        : (json['is_online'] as bool? ?? false),
    lastActivityTime: json['last_activity_time'] as int? ?? 0,
  );

  factory UserDto.testing() => const UserDto(
    id: 0,
    username: 'TEST_USERNAME',
    profileImage: null,
    isCurrent: true,
    isOnline: false,
    lastActivityTime: 0,
  );
  final int id;
  final String username;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_current')
  final bool isCurrent;

  /// online status
  final bool isOnline;
  final int lastActivityTime;

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  Map<String, dynamic> toLocalJson() => {
    'id': id,
    'username': username,
    'profile_image': profileImage,
    'is_current': isCurrent ? 1 : 0,
    'is_online': isOnline ? 1 : 0,
    'last_activity_time': lastActivityTime,
  };

  @override
  List<Object?> get props => [
    id,
    username,
    profileImage,
    isCurrent,
    isOnline,
    lastActivityTime,
  ];
}
