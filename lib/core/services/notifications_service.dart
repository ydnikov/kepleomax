import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/di/initialize_dependencies.dart';
import 'package:kepleomax/core/extensions/rtc_session_description_extension.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';
import 'package:kepleomax/core/services/calls_notifications_service.dart';
import 'package:kepleomax/core/services/calls_service.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> setupFlutterNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'Base notifications channel',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _handleAppOpened,
    );
  }

  /// will work in any environment except for testing
  Future<void> init() async {
    if (flavor.isTesting) return;

    await _messaging.requestPermission();

    await setupFlutterNotifications();

    FirebaseMessaging.onMessage.listen(handleNotification);

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    final notificationAppLaunchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      if (notificationAppLaunchDetails!.notificationResponse != null) {
        _handleAppOpened(notificationAppLaunchDetails.notificationResponse!);
      }
    }
  }

  int _openedChatId = -1;

  void blockNotificationsFromChat(int chatId) {
    _openedChatId = chatId;
  }

  void enableAllNotifications() {
    _openedChatId = -1;
  }

  void closeNotification(int id) {
    _localNotifications.cancel(id);
  }

  void closeNotifications(Iterable<int> ids) {
    for (final id in ids) {
      _localNotifications.cancel(id);
    }
  }

  void closeWithChatId(int chatId) {
    _localNotifications.getActiveNotifications().then((activeNotifications) {
      for (final notification in activeNotifications) {
        if (notification.payload == chatId.toString()) {
          _localNotifications.cancel(notification.id!);
        }
      }
    });
  }

  Future<void> handleNotification(RemoteMessage message) async {
    // TODO came up with something
    // final userProvider = UserProvider(prefs: await SharedPreferences.getInstance());
    // final user = await userProvider.getSavedUser();
    // if (user == null) return;

    final List<int> messagesIds = message.data['ids'] == null
        ? []
        : (jsonDecode(message.data['ids'] as String) as List<dynamic>)
              .map<int>((id) => id as int)
              .toList();

    /// check type
    final type = message.data['type'] as String?;
    print('KlmLog newNotification, type: $type');
    if (type == null) return;

    switch (type) {
      case 'new':
      case 'new_missed_call':
        {
          if (type == 'new_missed_call') {
            await CallsNotificationsService.instance.hideNotification(
              message.data['call_id'] as String,
            );
          }

          /// check chat_id
          final chatId = message.data['chat_id'] as String?;
          if (chatId == null) return;
          if (_openedChatId != -1 && chatId == _openedChatId.toString()) return;

          final otherUser = UserDto.fromJson(
            jsonDecode(message.data['other_user'] as String) as Map<String, dynamic>,
          );

          await _localNotifications.show(
            messagesIds[0],
            message.data['title'] as String,
            message.data['body'] as String,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'Base notifications channel',
                importance: Importance.max,
                priority: Priority.max,
                icon: '@drawable/icon_transparent',
              ),
              iOS: DarwinNotificationDetails(),
            ),
            payload: jsonEncode({
              'chat_id': int.parse(chatId),
              'other_user': otherUser.toJson(),
            }),
          );
          break;
        }

      case 'cancel':
        {
          for (final id in messagesIds) {
            unawaited(_localNotifications.cancel(id));
          }
          break;
        }

      case 'incoming_call':
        final sentAt = int.parse(message.data['sent_at'] as String);

        if (DateTime.now().millisecondsSinceEpoch - sentAt >=
            AppConstants.callingTimeout.inMilliseconds)
          break;

        await CallsNotificationsService.instance.showIncomingCall(
          id: message.data['id'] as String,
          otherUser: UserDto.fromJson(
            jsonDecode(message.data['other_user'] as String) as Map<String, dynamic>,
          ),
          startedAt: DateTime.fromMillisecondsSinceEpoch(sentAt),
          offer: RtcSessionDescriptionFromJsonExtension.fromNotificationExtra(
            message.data,
          ),
        );
        break;

      case 'stop_call':
        await CallsNotificationsService.instance.hideNotification(
          message.data['call_id'] as String,
        );
        if (message.data['only_hide_notification'] != 'true') {
          print('KlmLog only_hide_notification == false');
          CallsService.instance.callEnded();
        }
        break;
    }
  }

  void _handleAppOpened(NotificationResponse response) {
    if (response.payload == null) return;

    try {
      final payload = jsonDecode(response.payload!) as Map<String, dynamic>;
      final chatId = payload['chat_id'] as int;
      final otherUser = UserDto.fromJson(
        payload['other_user'] as Map<String, dynamic>,
      );

      mainNavigatorGlobalKey.currentState!.push(
        ChatPage(chatId: chatId, otherUser: User.fromDto(otherUser)),
      );
    } catch (e, st) {
      logger.e(e, stackTrace: st);
    }
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  // print('KlmLog onBackgroundMessage, type: ${message.data['type']}');

  await Firebase.initializeApp();
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.handleNotification(message);

  if (message.data['type'] == 'incoming_call') {
    Future(() async {
      if (CallsNotificationsService.instance.ignoreEvents) return;

      /// ONLY IF ISOLATE IN THE BACKGROUND - elementAt(0) will be Event.actionCallIncoming
      final event = await FlutterCallkitIncoming.onEvent
          .skipWhile((event) => event?.event == Event.actionCallIncoming)
          .first
          .timeout(AppConstants.callingTimeout);

      print(
        'KlmLog secondEvent: ${event?.event}, ignoreEvents: ${CallsNotificationsService.instance.ignoreEvents}',
      );
      if (CallsNotificationsService.instance.ignoreEvents) return;
      if (event?.event == Event.actionCallDecline) {
        await sendDeclineApiCall(event!.body['extra']['id'] as String);
      }
    }).ignore();
  }
}

@pragma('vm:entry-point')
Future<void> sendDeclineApiCall(String callId) async {
  final dp = await initializeDependencies(
    onlySteps: [
      DiStep.storages,
      DiStep.localDataSources,
      DiStep.dio,
      DiStep.tokenProvider,
      DiStep.authApis,
      DiStep.auth,
      DiStep.apis,
    ],
  );
  print('KlnLog declineCall from background');
  await dp.callsApi.endCall(id: callId, fcmToken: null); // TODO null is right?
}
