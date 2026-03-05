import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kepleomax/core/data/auth_repository.dart';
import 'package:kepleomax/core/data/local_data_sources/local_database_manager.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/token_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthController {
  User? get user;

  void init();

  Future<void> registerUser({required String email, required String password});

  Future<void> login({required String email, required String password});

  Future<void> logout();

  Future<void> setUser(User? newUser);

  void addListener(VoidCallback listener);

  void removeAllListeners();
}

class AuthControllerImpl implements AuthController {
  AuthControllerImpl({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required TokenProvider tokenProvider,
    required SharedPreferences prefs,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       _tokenProvider = tokenProvider,
       _prefs = prefs;

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final TokenProvider _tokenProvider;
  final SharedPreferences _prefs;

  User? _user;

  final List<VoidCallback> _listeners = [];

  static const _fcmKey = 'fcm_key';

  @override
  User? get user => _user;

  @override
  void init() {
    final user = _userRepository.getCurrentUserFromCache();
    _user = user;

    if (_user == null || flavor.isTesting) return;

    Future(() async {
      try {
        final user = await _userRepository.getUser(userId: _user!.id);
        await setUser(user);
      } catch (e, st) {
        logger.e(e, stackTrace: st);
      }
    });
  }

  @override
  Future<void> registerUser({required String email, required String password}) =>
      _authRepository.register(email: email, password: password);

  @override
  Future<void> login({required String email, required String password}) async {
    final res = await _authRepository.login(email: email, password: password);

    await _tokenProvider.saveAccessToken(res.accessToken);
    await _tokenProvider.saveRefreshToken(res.refreshToken);
    await setUser(User.fromDto(res.user));
  }

  @override
  Future<void> logout() async {
    if (_user == null) return;

    try {
      await setUser(null);
      LocalDatabaseManager.reset().ignore();
      final refreshToken = await _tokenProvider.getRefreshToken();
      if (refreshToken != null) {
        try {
          await _authRepository.logout(refreshToken: refreshToken);
        } catch (e, st) {
          logger.e(e, stackTrace: st);
        }
      }
    } catch (e, st) {
      logger.e(e, stackTrace: st);
    } finally {
      await _tokenProvider.clearAll();
    }
  }

  @override
  Future<void> setUser(User? newUser) async {
    if (newUser == _user) return;
    if (newUser?.isCurrent == false) {
      logger.e('Trying to setUser, but newUser.isCurrent == false');
      return;
    }

    _user = newUser;
    await _userRepository.setCurrentUser(newUser);
    for (final listener in _listeners) {
      listener();
    }

    /// TODO make it better
    if (flavor.isTesting) return;

    if (newUser != null) {
      await _checkFcmToken();
    } else {
      await _deleteFcmToken();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeAllListeners() {
    _listeners.clear();
  }

  Future<void> _checkFcmToken() async {
    /// TODO make better solution
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    final savedToken = _prefs.getString(_fcmKey);
    if (token == savedToken) return;

    await _userRepository
        .addFCMToken(token: token)
        .then((result) {
          if (result) {
            _prefs.setString(_fcmKey, token);

            /// token successfully stored on the server
          }
        })
        .onError((e, st) {
          _prefs.remove(_fcmKey);
          logger.e('failed to set fcm token: $e', stackTrace: st);
        });
  }

  /// I'm not sure it works
  Future<void> _deleteFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await _prefs.remove(_fcmKey);
    await FirebaseMessaging.instance.deleteToken();

    await _userRepository.deleteFCMToken(token: token).onError((e, st) {
      logger.e('failed to delete fcm token: $e', stackTrace: st);
    });
  }
}
