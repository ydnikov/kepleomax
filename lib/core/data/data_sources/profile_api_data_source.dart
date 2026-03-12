import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/models/user_profile.dart';
import 'package:kepleomax/core/network/apis/profile/profile_api.dart';
import 'package:kepleomax/core/network/apis/profile/profile_dtos.dart';

abstract class ProfileApiDataSource {
  Future<UserProfile> getProfile({required int userId});

  Future<UserProfile> editProfile({
    required UserProfile newProfile,
    required String? newProfileImagePath,
    required bool updateProfileImage,
  });
}

class ProfileApiDataSourceImpl implements ProfileApiDataSource {
  ProfileApiDataSourceImpl({required ProfileApi profileApi}) : _api = profileApi;

  final ProfileApi _api;

  @override
  Future<UserProfile> getProfile({required int userId}) async {
    final res = await _api.getProfile(userId.toString());

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ??
            "Failed to get user's profile: ${res.response.statusCode}",
      );
    }

    return UserProfile(
      user: User.fromDto(res.data.data!.user),
      description: res.data.data!.description,
    );
  }

  @override
  Future<UserProfile> editProfile({
    required UserProfile newProfile,
    required String? newProfileImagePath,
    required bool updateProfileImage,
  }) async {
    final res = await _api.editProfile(
      EditProfileRequestDto(
        username: newProfile.user.username.trim(),
        description: newProfile.description.trim(),
        profileImage: newProfileImagePath,
        updateImage: updateProfileImage,
      ),
    );

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to update profile: ${res.response.statusCode}',
      );
    }

    return UserProfile(
      user: User.fromDto(res.data.data!.user),
      description: res.data.data!.description,
    );
  }
}
