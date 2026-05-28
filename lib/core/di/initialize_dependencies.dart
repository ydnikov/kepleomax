import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kepleomax/core/auth/auth_controller.dart';
import 'package:kepleomax/core/data/auth_repository.dart';
import 'package:kepleomax/core/data/data_sources/fcm_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/files_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/profile_api_data_source.dart';
import 'package:kepleomax/core/data/data_sources/users_api_data_source.dart';
import 'package:kepleomax/core/data/local_data_sources/drafts_local_data_source.dart';
import 'package:kepleomax/core/navigation/url_launcher.dart';
import 'package:kepleomax/core/network/apis/channels/channel_api.dart';
import 'package:kepleomax/core/network/apis/fcm/fcm_api.dart';
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
import 'package:kepleomax/features/people/data/people_repository.dart';
import 'package:kepleomax/features/post/data/post_repository.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/network/apis/auth/auth_api.dart';
import 'package:kepleomax/core/network/apis/calls/calls_api.dart';
import 'package:kepleomax/core/network/apis/chats/chats_api.dart';
import 'package:kepleomax/core/network/apis/files/files_api.dart';
import 'package:kepleomax/core/network/apis/messages/messages_api.dart';
import 'package:kepleomax/core/network/apis/posts/post_api.dart';
import 'package:kepleomax/core/network/apis/profile/profile_api.dart';
import 'package:kepleomax/core/network/apis/user/users_api.dart';
import 'package:kepleomax/core/network/middlewares/auth_interceptor.dart';
import 'package:kepleomax/core/network/token_provider.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/settings/app_settings.dart';
import 'package:kepleomax/features/call/data/calls_repository.dart';
import 'package:kepleomax/features/call/data/peer_connection_controller.dart';
import 'package:kepleomax/firebase_options.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

Future<Dependencies> initializeDependencies({List<DiStep>? onlySteps}) async {
  final dp = Dependencies();

  for (final step in _steps) {
    try {
      if (onlySteps == null || onlySteps.contains(step.step)) {
        await step.call(dp);
      }
    } catch (e, st) {
      logger.e('Error while initializing step ${step.step}: $e', stackTrace: st);
      rethrow;
    }
  }

  return dp;
}

List<_InitializationStep> _steps = [
  _InitializationStep(DiStep.storages, (dp) async {
    dp
      ..sharedPrefs = await SharedPreferences.getInstance()
      ..appSettings = AppSettingsImpl(prefs: dp.sharedPrefs)
      ..secureStorage = const FlutterSecureStorage();
    CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;
  }),

  _InitializationStep(DiStep.localDataSources, (dp) async {
    final db = await LocalDatabaseManager.getDatabase();
    dp
      ..database = db
      ..messagesLocalDataSource = MessagesLocalDataSourceImpl(database: db)
      ..draftsLocalDataSource = DraftsLocalDataSourceImpl(database: db)
      ..chatsLocalDataSource = ChatsLocalDataSourceImpl(database: db)
      ..usersLocalDataSource = UsersLocalDataSourceImpl(
        database: db,
        prefs: dp.sharedPrefs,
      );
  }),

  _InitializationStep(DiStep.dio, (dp) async {
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

  _InitializationStep(DiStep.tokenProvider, (dp) async {
    dp.tokenProvider = TokenProviderImpl(
      prefs: dp.sharedPrefs,
      secureStorage: dp.secureStorage,
      // needs its own dio, cause the current one will be locked
      dio: Dio(
        BaseOptions(
          validateStatus: (_) => true,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 10),
        ),
      )..interceptors.add(dp.prettyDioLogger),
    );
  }),

  _InitializationStep(DiStep.authApis, (dp) async {
    dp
      ..authApi = AuthApi(dp.dio, flavor.baseUrl)
      ..userApi = UsersApi(dp.dio, flavor.baseUrl)
      ..profileApi = ProfileApi(dp.dio, flavor.baseUrl)
      ..filesApi = FilesApi(dp.dio, flavor.baseUrl)
      ..fcmApi = FcmApi(dp.dio, flavor.baseUrl);
  }),

  _InitializationStep(DiStep.apis, (dp) async {
    dp
      ..postApi = PostApi(dp.dio, flavor.baseUrl)
      ..messagesApi = MessagesApi(dp.dio, flavor.baseUrl)
      ..chatsApi = ChatsApi(dp.dio, flavor.baseUrl)
      ..callsApi = CallsApi(dp.dio, flavor.baseUrl)
      ..channelApi = ChannelApi(dp.dio, flavor.baseUrl);
  }),

  _InitializationStep(DiStep.apiDataSources, (dp) async {
    dp
      ..usersApiDataSource = UsersApiDataSourceImpl(usersApi: dp.userApi)
      ..profileApiDataSource = ProfileApiDataSourceImpl(profileApi: dp.profileApi)
      ..filesApiDataSource = FilesApiDataSourceImpl(filesApi: dp.filesApi)
      ..fcmApiDataSourceImpl = FcmApiDataSourceImpl(fcmApi: dp.fcmApi)
      ..chatsApiDataSource = ChatsApiDataSourceImpl(chatsApi: dp.chatsApi)
      ..messagesApiDataSource = MessagesApiDataSourceImpl(
        messagesApi: dp.messagesApi,
      );
  }),

  _InitializationStep(DiStep.auth, (dp) async {
    dp.userRepository = UserRepositoryImpl(
      profileApiDataSource: ProfileApiDataSourceImpl(profileApi: dp.profileApi),
      filesApiDataSource: FilesApiDataSourceImpl(filesApi: dp.filesApi),
      userApiDataSource: UsersApiDataSourceImpl(usersApi: dp.userApi),
      fcmApiDataSource: FcmApiDataSourceImpl(fcmApi: dp.fcmApi),
      usersLocalDataSource: dp.usersLocalDataSource,
    );

    final authController = AuthControllerImpl(
      authRepository: AuthRepositoryImpl(authApi: dp.authApi),
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

  _InitializationStep(DiStep.webSockets, (dp) async {
    dp
      ..klmWebSocketBuilder = (() =>
          KlmWebSocketImpl(baseUrl: flavor.baseUrl, tokenProvider: dp.tokenProvider))
      ..messengerWebSocketBuilder = (() =>
          MessengerWebSocketImpl(klmWebSocket: dp.read<KlmWebSocket>()))
      ..rtcWebSocketBuilder = (() =>
          RtcWebSocketImpl(klmWebSocket: dp.read<KlmWebSocket>()));
  }),

  _InitializationStep(DiStep.repositories, (dp) async {
    dp
      ..filesRepository = FilesRepositoryImpl(
        filesApiDataSource: dp.filesApiDataSource,
      )
      ..postRepository = PostRepositoryImpl(postApi: dp.postApi)
      ..connectionRepositoryBuilder = (() =>
          ConnectionRepositoryImpl(klmWebSocket: dp.read<KlmWebSocket>()))
      ..messengerRepositoryBuilder = (() => MessengerRepositoryImpl(
        messengerWebSocket: dp.read<MessengerWebSocket>(),
        messagesApiDataSource: MessagesApiDataSourceImpl(
          messagesApi: dp.messagesApi,
        ),
        messagesLocalDataSource: dp.messagesLocalDataSource,
        draftsLocalDataSource: dp.draftsLocalDataSource,
        chatsApiDataSource: dp.chatsApiDataSource,
        chatsLocalDataSource: dp.chatsLocalDataSource,
        usersLocalDataSource: dp.usersLocalDataSource,
        combiner: CombineCacheAndApi(dp.messagesLocalDataSource),
      ))
      ..peopleRepositoryBuilder = (() => PeopleRepositoryImpl(
        userApiDataSource: dp.usersApiDataSource,
        usersLocalDataSource: dp.usersLocalDataSource,
      ))
      ..chatsRepositoryBuilder = (() => ChatsRepositoryImpl(
        chatsApiDataSource: dp.chatsApiDataSource,
        chatsLocalDataSource: dp.chatsLocalDataSource,
      ))
      ..callsRepositoryBuilder = (() => CallsRepositoryImpl(
        callsApi: dp.callsApi,
        rtcWebSocket: dp.read<RtcWebSocket>(),
        peerConnectionController: PeerConnectionControllerImpl(),
      ));
  }),

  _InitializationStep(DiStep.navigation, (dp) async {
    dp.klmUrlLauncher = KlmUrlLauncher(
      chatsRepository: ChatsRepositoryImpl(
        chatsApiDataSource: dp.chatsApiDataSource,
        chatsLocalDataSource: dp.chatsLocalDataSource,
      ),
    );
  }),

  _InitializationStep(DiStep.firebase, (_) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }),

  _InitializationStep(DiStep.globalSettings, (_) async {
    VisibilityDetectorController.instance.updateInterval = const Duration(
      milliseconds: 100,
    );
  }),
];

class _InitializationStep {
  _InitializationStep(this.step, this.call);

  final DiStep step;
  final Future<void> Function(Dependencies) call;
}

enum DiStep {
  storages,
  localDataSources,
  dio,
  tokenProvider,
  authApis,
  auth,
  webSockets,
  apis,
  apiDataSources,
  repositories,
  navigation,
  firebase,
  globalSettings,
}
