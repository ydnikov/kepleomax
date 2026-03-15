import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String username,
    required String? profileImage,
    required bool isCurrent,
    @Default(false) bool isOnline,

    /// TODO change to DateTime
    @Default(0) int lastActivityTime,
  }) = _User;

  factory User.fromDto(UserDto dto) => User(
    id: dto.id,
    username: dto.username,
    profileImage: dto.profileImage,
    isCurrent: dto.isCurrent,
    isOnline: dto.isOnline,
    lastActivityTime: dto.lastActivityTime,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.loading() => User(
    id: -1,
    username: BoneMock.name,
    profileImage: null,
    isCurrent: false,
    isOnline: false,
    lastActivityTime: 0,
  );

  factory User.testing() => User.fromDto(UserDto.testing());

  const User._();

  /// TODO write what is it
  bool get showOnlineStatus {
    return isOnline &&
        lastActivityTime +
                AppConstants.markAsOfflineAfterInactivity.inMilliseconds >
            DateTime.now().millisecondsSinceEpoch;
  }

  UserDto toDto() => UserDto(
    id: id,
    username: username,
    profileImage: profileImage,
    isCurrent: isCurrent,
    isOnline: isOnline,
    lastActivityTime: lastActivityTime,
  );
}
