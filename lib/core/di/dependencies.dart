import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kepleomax/core/auth/auth_controller.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/data/data_sources/fcm_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/files_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/messages_api_data_sources.dart';
import 'package:kepleomax/core/data/data_sources/profile_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/users_api_data_source.dart';
import 'package:kepleomax/core/data/files_repository.dart';
import 'package:kepleomax/core/data/local_data_sources/chats_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/drafts_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/messages_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/users_local_data_source.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/di/disposable.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/navigation/url_launcher.dart';
import 'package:kepleomax/core/network/apis/auth/auth_api.dart';
import 'package:kepleomax/core/network/apis/calls/calls_api.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/chats/chats_api.dart';
import 'package:kepleomax/core/network/apis/fcm/fcm_api.dart';
import 'package:kepleomax/core/network/apis/files/files_api.dart';
import 'package:kepleomax/core/network/apis/messages/messages_api.dart';
import 'package:kepleomax/core/network/apis/posts/post_api.dart';
import 'package:kepleomax/core/network/apis/profile/profile_api.dart';
import 'package:kepleomax/core/network/apis/user/users_api.dart';
import 'package:kepleomax/core/network/token_provider.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/settings/app_settings.dart';
import 'package:kepleomax/features/call/data/calls_repository.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';
import 'package:kepleomax/features/chats/data/chats_repository.dart';
import 'package:kepleomax/features/people/data/people_repository.dart';
import 'package:kepleomax/features/post/data/post_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Dependencies {
  /// storages
  late final AuthController authController;
  late final TokenProvider tokenProvider;
  late final SharedPreferences sharedPrefs;
  late final FlutterSecureStorage secureStorage;
  late final PrettyDioLogger prettyDioLogger;
  late final Database database;
  late final AppSettings appSettings;

  /// navigation
  late final KlmUrlLauncher klmUrlLauncher;

  /// apis
  late final Dio dio;
  late final AuthApi authApi;
  late final UsersApi userApi;
  late final FcmApi fcmApi;
  late final ProfileApi profileApi;
  late final FilesApi filesApi;
  late final PostApi postApi;
  late final MessagesApi messagesApi;
  late final ChatsApi chatsApi;
  late final CallsApi callsApi;
  late final ChannelApi channelApi;

  /// webSockets
  late final KlmWebSocket Function() klmWebSocketBuilder;
  late final MessengerWebSocket Function() messengerWebSocketBuilder;
  late final RtcWebSocket Function() rtcWebSocketBuilder;

  /// local dataSources
  late final MessagesLocalDataSource messagesLocalDataSource;
  late final DraftsLocalDataSource draftsLocalDataSource;
  late final UsersLocalDataSource usersLocalDataSource;
  late final ChatsLocalDataSource chatsLocalDataSource;

  /// api dataSources
  late final UsersApiDataSource usersApiDataSource;
  late final ProfileApiDataSource profileApiDataSource;
  late final FilesApiDataSource filesApiDataSource;
  late final FcmApiDataSource fcmApiDataSourceImpl;
  late final ChatsApiDataSource chatsApiDataSource;
  late final MessagesApiDataSource messagesApiDataSource;

  /// singleton repositories (with no state)
  late final UserRepository userRepository;
  late final PostRepository postRepository;
  late final FilesRepository filesRepository;

  /// one place use repositories
  late final PeopleRepository Function() peopleRepositoryBuilder;
  late final ChatsRepository Function() chatsRepositoryBuilder;
  late final CallsRepository Function() callsRepositoryBuilder;

  /// multi place use repositories
  late final ConnectionRepository Function() connectionRepositoryBuilder;
  late final MessengerRepository Function() messengerRepositoryBuilder;
  late final ChannelRepository Function() channelRepositoryBuilder;

  final _map = HashMap<Type, Object>();
  final _referenceCounts = HashMap<Type, int>();

  T read<T>() {
    if (_map[T] == null) {
      throw Exception('$T has not been initialized in the dependencies');
    }
    return _map[T] as T;
  }

  void provideByType(Type type, Object value) {
    // if (value is! type) {
    //   throw Exception('Failed to provide dependency: type mismatch');
    // } // TODO

    if (!_map.containsKey(type)) {
      _map[type] = value;
    }
    _referenceCounts[type] = (_referenceCounts[type] ?? 0) + 1;
  }

  void provide<T extends Object>(T value) => provideByType(T, value);

  void provideAll(Map<Type, Object> values) {
    for (final entry in values.entries) {
      provideByType(entry.key, entry.value);
    }
  }

  void removeByType(Type type) {
    if (!_map.containsKey(type)) {
      logger.w(
        "Attempt to remove the $type from dependencies, but it doesn't contain it",
      );
      return;
    }
    _referenceCounts[type] = _referenceCounts[type]! - 1;
    if (_referenceCounts[type] == 0) {
      final object = _map[type]!;
      if (object is Disposable) {
        object.dispose();
      }
      _map.remove(type);
    }
  }

  void remove<T>() => removeByType(T);

  void removeAll(List<Type> types) {
    for (final type in types) {
      removeByType(type);
    }
  }

  bool has<T>() => _map[T] != null;

  Widget inject({required Widget child}) =>
      InheritedDependencies(dependencies: this, child: child);

  static Dependencies of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<InheritedDependencies>()!.dependencies;
}

class InheritedDependencies extends InheritedWidget {
  const InheritedDependencies({
    required this.dependencies,
    required super.child,
    super.key,
  });

  final Dependencies dependencies;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
