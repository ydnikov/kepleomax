import 'dart:async';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallsNotificationsService {
  CallsNotificationsService._();

  static final CallsNotificationsService _instance = CallsNotificationsService._();

  static CallsNotificationsService get instance => _instance;

  static SharedPreferences? _prefs;
  static const _ignoreEventsDuration = Duration(seconds: 1);
  static const _ignoreEventsKey = '__ignore_events_key__';

  bool get ignoreEvents => _prefs?.getBool(_ignoreEventsKey) ?? false;

  Future<void> showIncomingCall({
    required String id,
    required UserDto otherUser,
    required DateTime startedAt,
  }) async {
    final params = _generateCallKitParams(id, otherUser, startedAt: startedAt);
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endCall(String callId) async {
    await _startIgnoringEvents();

    print('KlmLog endCallNotification');
    await FlutterCallkitIncoming.endCall(callId);

    await _stopForeground();

    unawaited(_waitAndStopIgnoringEvents());
  }

  Future<void> endAllCalls() async {
    await _startIgnoringEvents();

    print('KlmLog2 endAllCalls');
    await FlutterCallkitIncoming.endAllCalls();

    unawaited(_waitAndStopIgnoringEvents());
  }

  Future<void> acceptCall(String callId) async {
    await _startIgnoringEvents();

    await FlutterCallkitIncoming.setCallConnected(callId);
    await _startForeground();

    unawaited(_waitAndStopIgnoringEvents());
  }

  Future<void> registerNewCall(String callId, {required String otherUserName}) async {
    await _startIgnoringEvents();

    await FlutterCallkitIncoming.startCall(CallKitParams(
      id: callId,
      type: 1,
      nameCaller: otherUserName,
      appName: 'KepLeoMax',
      android: const AndroidParams(
        isCustomNotification: true,
        isImportant: true,
        isShowFullLockedScreen: true,
      ),
    ));
    await _startForeground();

    unawaited(_waitAndStopIgnoringEvents());
  }

  Future<void> _startForeground() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'webrtc_mic_protection',
        channelName: 'Call Audio Protection',
        channelDescription: 'Keeps microphone active',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,

      ),
      iosNotificationOptions: const IOSNotificationOptions(showNotification: false),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowAutoRestart: false,
        stopWithTask: false,
      ),
    );

    await FlutterForegroundTask.startService(
      notificationTitle: 'Connected to Call',
      notificationText: 'Microphone protection is active',
      serviceId: 250, // random number
      serviceTypes: [ForegroundServiceTypes.microphone],
    );
  }

  Future<void> _stopForeground() async {
    await FlutterForegroundTask.stopService();
    await FlutterForegroundTask.clearAllData();
  }

  Future<void> _startIgnoringEvents() async {
    _prefs ??= await SharedPreferences.getInstance();

    await _prefs!.setBool(_ignoreEventsKey, true);
  }

  Future<void> _waitAndStopIgnoringEvents() async {
    _prefs ??= await SharedPreferences.getInstance();

    await Future<void>.delayed(_ignoreEventsDuration);
    await _prefs!.setBool(_ignoreEventsKey, false);
  }

  CallKitParams _generateCallKitParams(
    String id,
    UserDto otherUser, {
    required DateTime startedAt,
  }) => CallKitParams(
    id: id,
    nameCaller: otherUser.username,
    appName: 'KepLeoMax',
    avatar: otherUser.profileImage,
    type: 1,
    textAccept: 'Accept',
    textDecline: 'Decline',
    callingNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Video call',
      callbackText: 'End call',

    ),
    missedCallNotification: const NotificationParams(
      showNotification: false,
      isShowCallback: false,
    ),
    duration: const Duration(hours: 3).inMilliseconds, // TODO
        // AppConstants.callingTimeout.inMilliseconds -
        // (DateTime.now().millisecondsSinceEpoch - startedAt.millisecondsSinceEpoch),
    extra: {'id': id, 'other_user_id': otherUser.id},
    android: AndroidParams(
      isCustomNotification: false,
      isShowLogo: false,
      isCustomSmallExNotification: true,
      isImportant: true,
      isShowFullLockedScreen: true,
      isBot: false,
      logoUrl: otherUser.profileImage,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#2196F3',
      backgroundUrl: otherUser.profileImage,
      actionColor: '#4CAF50',
      textColor: '#ffffff',
      incomingCallNotificationChannelName: 'Incoming Call',
      missedCallNotificationChannelName: 'Missed Call',
      isShowCallID: true,
    ),
  );
}
