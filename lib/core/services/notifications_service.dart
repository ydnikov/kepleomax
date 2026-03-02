import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';
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

    FirebaseMessaging.onMessage.listen(showNotification);

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

  Future<void> showNotification(RemoteMessage message) async {
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
    if (type == null) return;

    switch (type) {
      case 'new':
        {
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
                importance: Importance.high,
                priority: Priority.high,
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
        await CallsService.instance.showIncomingCall(
          otherUser: UserDto.fromJson(
            jsonDecode(message.data['other_user'] as String) as Map<String, dynamic>,
          ),
          offer: RTCSessionDescription(
            message.data['offer_sdp'] as String?,
            message.data['offer_type'] as String?,
          ),
        );
        break;

      case 'end_incoming_call':
        {
          final userDto = UserDto.fromJson(
            jsonDecode(message.data['other_user'] as String) as Map<String, dynamic>,
          );
          await CallsService.instance.markCallAsMissed(otherUser: userDto);
          break;
        }
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

      (mainNavigatorGlobalKey.currentState as AppNavigatorState).push(
        ChatPage(chatId: chatId, otherUser: User.fromDto(otherUser)),
      );
    } catch (e, st) {
      logger.e(e, stackTrace: st);
    }
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}
