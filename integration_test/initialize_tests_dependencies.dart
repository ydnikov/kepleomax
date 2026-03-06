import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kepleomax/core/auth/auth_controller.dart';
import 'package:kepleomax/core/data/auth_repository.dart';
import 'package:kepleomax/features/chats/data/chats_repository.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/data/data_sources/messages_api_data_sources.dart';
import 'package:kepleomax/core/data/files_repository.dart';
import 'package:kepleomax/core/data/local_data_sources/chats_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/local_database_manager.dart';
import 'package:kepleomax/core/data/local_data_sources/messages_local_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/users_local_data_source.dart';
import 'package:kepleomax/core/data/messenger/combine_cache_and_api.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/features/post/data/post_repository.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/network/apis/auth/auth_api.dart';
import 'package:kepleomax/core/network/apis/files/files_api.dart';
import 'package:kepleomax/core/network/apis/posts/post_api.dart';
import 'package:kepleomax/core/network/apis/profile/profile_api.dart';
import 'package:kepleomax/core/network/middlewares/auth_interceptor.dart';
import 'package:kepleomax/core/settings/app_settings.dart';
import 'package:kepleomax/firebase_options.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'mocks/fake_user_api.dart';
import 'mocks/mock_klm_web_socket.dart';
import 'mocks/mock_messages_web_socket.dart';
import 'mocks/mock_rtc_web_socket.dart';
import 'mocks/mock_token_provider.dart';
import 'mocks/mockito_mocks.mocks.dart';

Future<Dependencies> initializeTestsDependencies({bool useMocks = false}) async {
  final dp = Dependencies();

  for (final step in _steps) {
    try {
      await step.call(dp);
    } catch (e, st) {
      logger.e('Error while initializing step ${step.name}: $e', stackTrace: st);
      rethrow;
    }
  }

  return dp;
}

List<_InitializationStep> _steps = [
  _InitializationStep('storages', (dp) async {
    dp
      ..sharedPrefs = await SharedPreferences.getInstance()
      ..appSettings = AppSettingsImpl(prefs: dp.sharedPrefs)
      ..secureStorage = const FlutterSecureStorage();
    CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;
  }),

  _InitializationStep('local_data_sources', (dp) async {
    final db = await LocalDatabaseManager.getDatabase();
    dp
      ..database = db
      ..usersLocalDataSource = UsersLocalDataSourceImpl(
        database: db,
        prefs: dp.sharedPrefs,
      )
      ..messagesLocalDataSource = MessagesLocalDataSourceImpl(database: db)
      ..chatsLocalDataSource = ChatsLocalDataSourceImpl(database: db);
  }),

  _InitializationStep('dioLogger, dio', (dp) async {
    dp.prettyDioLogger = PrettyDioLogger(
      request: kDebugMode,
      requestHeader: kDebugMode,
      requestBody: kDebugMode,
      responseHeader: kDebugMode,
      responseBody: kDebugMode,
      error: kDebugMode,
      logPrint: (Object object) => debugPrint(object.toString(), wrapWidth: 1024),
    );

    final dio = Dio(
      BaseOptions(
        validateStatus: (_) => true,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    )..interceptors.add(dp.prettyDioLogger);

    dp.dio = dio;
  }),

  _InitializationStep('token_provider', (dp) async {
    dp.tokenProvider = MockTokenProvider();
  }),

  _InitializationStep('auth_apis', (dp) async {
    dp
      ..authApi = AuthApi(dp.dio, flavor.baseUrl)
      ..userApi = FakeUserApi()
      ..profileApi = ProfileApi(dp.dio, flavor.baseUrl)
      ..filesApi = FilesApi(dp.dio, flavor.baseUrl);
  }),

  _InitializationStep('auth', (dp) async {
    dp
      ..authRepository = AuthRepositoryImpl(authApi: dp.authApi)
      ..userRepository = UserRepositoryImpl(
        profileApi: dp.profileApi,
        filesApi: dp.filesApi,
        userApi: dp.userApi,
        usersLocalDataSource: dp.usersLocalDataSource,
      );

    final authController = AuthControllerImpl(
      authRepository: dp.authRepository,
      userRepository: dp.userRepository,
      tokenProvider: dp.tokenProvider,
      prefs: dp.sharedPrefs,
    )..init();
    dp.authController = authController;

    dp.dio.interceptors.add(
      AuthInterceptor(
        tokenProvider: dp.tokenProvider,
        authController: dp.authController,
      ),
    );
  }),

  _InitializationStep('web_socket', (dp) async {
    dp
      ..klmWebSocket = MockKlmWebSocket()
      ..messengerWebSocket = MockMessengerWebSocket()
      ..rtcWebSocket = MockRtcWebSocket();
  }),

  _InitializationStep('apis', (dp) async {
    dp
      ..postApi = PostApi(dp.dio, flavor.baseUrl)
      ..messagesApi = MockMessagesApi()
      ..chatsApi = MockChatsApi();
  }),

  _InitializationStep('repositories', (dp) async {
    final chatsApiDataSource = ChatsApiDataSourceImpl(chatsApi: dp.chatsApi);

    dp
      ..filesRepository = FilesRepositoryImpl(filesApi: dp.filesApi)
      ..postRepository = PostRepositoryImpl(postApi: dp.postApi)
      ..connectionRepository = ConnectionRepositoryImpl(
        klmWebSocket: dp.klmWebSocket,
      )
      ..messengerRepository = MessengerRepositoryImpl(
        webSocket: dp.messengerWebSocket,
        messagesApiDataSource: MessagesApiDataSourceImpl(
          messagesApi: dp.messagesApi,
        ),
        chatsApiDataSource: chatsApiDataSource,
        messagesLocalDataSource: dp.messagesLocalDataSource,
        chatsLocalDataSource: dp.chatsLocalDataSource,
        usersLocalDataSource: dp.usersLocalDataSource,
        combiner: CombineCacheAndApi(dp.messagesLocalDataSource),
      )
      ..chatsRepository = ChatsRepositoryImpl(
        chatsApi: chatsApiDataSource,
        chatsLocalDataSource: dp.chatsLocalDataSource,
      );
  }),

  _InitializationStep('firebase', (_) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }),

  _InitializationStep('global_settings', (_) async {
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 100,
    );
  }),
];

class _InitializationStep {
  _InitializationStep(this.name, this.call);

  final String name;
  final Future<void> Function(Dependencies) call;
}
