import 'dart:async';
import 'dart:io';

import 'package:kepleomax/core/data/data_sources/fcm_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/files_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/profile_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/users_api_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/users_local_data_source.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/models/user_profile.dart';

abstract class UserRepository {
  Future<User> getUser({required int userId});

  Future<UserProfile> getUserProfile(int userId);

  Future<UserProfile> updateProfile(UserProfile profile, {bool updateImage = false});

  /// search
  Future<bool> addFCMToken({required String token});

  Future<void> deleteFCMToken({required String token});

  /// cache currentUser
  User? getCurrentUserFromCache();

  Future<void> setCurrentUser(User? user);
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required ProfileApiDataSource profileApiDataSource,
    required FilesApiDataSource filesApiDataSource,
    required UsersApiDataSource userApiDataSource,
    required UsersLocalDataSource usersLocalDataSource,
    required FcmApiDataSource fcmApiDataSource,
  }) : _userApiSource = userApiDataSource,
       _profileApiSource = profileApiDataSource,
       _filesApiSource = filesApiDataSource,
       _usersLocalSource = usersLocalDataSource,
       _fcmApiSource = fcmApiDataSource;

  final UsersApiDataSource _userApiSource;
  final UsersLocalDataSource _usersLocalSource;
  final ProfileApiDataSource _profileApiSource;
  final FilesApiDataSource _filesApiSource;
  final FcmApiDataSource _fcmApiSource;

  @override
  Future<User> getUser({required int userId}) async {
    final dto = await _userApiSource.getUser(userId: userId);
    unawaited(_usersLocalSource.insert(dto));
    return User.fromDto(dto);
  }

  @override
  Future<UserProfile> getUserProfile(int userId) =>
      _profileApiSource.getProfile(userId: userId);

  @override
  Future<UserProfile> updateProfile(
    UserProfile profile, {
    bool updateImage = false,
  }) async {
    String? newImagePath;
    if (!updateImage) {
      newImagePath = null;
    } else {
      /// set newImagePath
      if (profile.user.profileImage == null || profile.user.profileImage!.isEmpty) {
        newImagePath = null;
      } else {
        newImagePath = await _filesApiSource.uploadFile(
          File(profile.user.profileImage!),
        );
      }
    }

    await _profileApiSource.editProfile(
      newProfile: profile,
      newProfileImagePath: newImagePath,
      updateProfileImage: updateImage,
    );

    return profile.copyWith(
      user: profile.user.copyWith(
        profileImage: newImagePath ?? profile.user.profileImage,
      ),
    );
  }

  @override
  Future<bool> addFCMToken({required String token}) => _fcmApiSource.addToken(token);

  @override
  Future<void> deleteFCMToken({required String token}) =>
      _fcmApiSource.deleteToken(token);

  @override
  User? getCurrentUserFromCache() => _usersLocalSource.getCurrentUser();

  @override
  Future<void> setCurrentUser(User? user) => _usersLocalSource.setCurrentUser(user);
}
