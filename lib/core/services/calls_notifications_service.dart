import 'dart:async';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallsNotificationsService {
  CallsNotificationsService._();

  static final CallsNotificationsService _instance = CallsNotificationsService._();

  static CallsNotificationsService get instance => _instance;

  static SharedPreferences? _prefs;
  static const _ignoreEventsKey = '__ignore_events_key__';

  bool get ignoreEventsAndReset {
    final value = _prefs?.getBool(_ignoreEventsKey) ?? false;

    if (value) _stopIgnoringEvent();

    return value;
  }

  Future<void> showIncomingCall({
    required String id,
    required UserDto otherUser,
    required DateTime startedAt,
  }) async {
    final params = _generateCallKitParams(id, otherUser, startedAt: startedAt);
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endCall(String callId) async {
    await _ignoreNextEventForSecond();

    print('KlmLog endCallNotification: $callId');
    await FlutterCallkitIncoming.endCall(callId);
    await _stopForeground();

    // await FlutterCallkitIncoming.hideCallkitIncoming(CallKitParams(id: callId));
    // await FlutterCallkitIncoming.endAllCalls();
  }

  /// doesn't trigger any event
  Future<void> hideIncomingNotification(String callId) async {
    print('KlmLog hideIncomingNotification: $callId');
    await FlutterCallkitIncoming.hideCallkitIncoming(CallKitParams(id: callId));
  }

  Future<void> setCallConnected(String callId) async {
    await _ignoreNextEventForSecond();

    print('KlmLog acceptCall: $callId');
    await FlutterCallkitIncoming.setCallConnected(callId);
    await _startForeground();
  }

  Future<void> registerNewCall(
    String callId, {
    required String otherUserName,
  }) async {
    await _ignoreNextEventForSecond();

    await _startForeground();

    await FlutterCallkitIncoming.startCall(
      CallKitParams(
        id: callId,
        type: 1,
        nameCaller: otherUserName,
        appName: 'KepLeoMax',
        android: const AndroidParams(
          isCustomNotification: true,
          isImportant: true,
          isShowFullLockedScreen: true,
        ),
        callingNotification: const NotificationParams(showNotification: false),
      ),
    );
  }

  /// before call it ensure you have mic permission
  Future<void> _startForeground() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      logger.e('Attempt to start microphone foreground service without permission');
      return;
    }

    // await Helper.setAndroidAudioConfiguration(
    //   AndroidAudioConfiguration(
    //     androidAudioMode: AndroidAudioMode.inCommunication,
    //     androidAudioFocusMode: AndroidAudioFocusMode.gainTransientExclusive,
    //   ),
    // );

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'webrtc_mic_protection',
        channelName: 'Call Audio Engine',
        channelDescription: 'Keeps microphone active',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.MIN,
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
      notificationTitle: 'Microphone is active',
      notificationText: 'In use for active call',
      serviceId: 250,
      // random number
      serviceTypes: [ForegroundServiceTypes.microphone],
      notificationIcon: const NotificationIcon(
        metaDataName: 'com.kepleomax.kepleomax.IC_NOTIFICATION',
      ),
    );
  }

  Future<void> _stopForeground() async {
    // await Helper.setAndroidAudioConfiguration(
    //   AndroidAudioConfiguration(
    //     androidAudioMode: AndroidAudioMode.normal,
    //     androidAudioFocusMode: AndroidAudioFocusMode.gain,
    //   ),
    // );

    await FlutterForegroundTask.stopService();
    await FlutterForegroundTask.clearAllData();
  }

  int _ignoreNextEventCalledTime = 0;

  Future<void> _ignoreNextEventForSecond() async {
    final ignoreStartTime = DateTime.now().millisecondsSinceEpoch;
    _ignoreNextEventCalledTime = ignoreStartTime;

    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(_ignoreEventsKey, true);

    Future.delayed(const Duration(seconds: 1), () {
      if (_ignoreNextEventCalledTime == ignoreStartTime) {
        _prefs!.setBool(_ignoreEventsKey, false);
      }
    });
  }

  Future<void> _stopIgnoringEvent() async {
    _prefs ??= await SharedPreferences.getInstance();

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
      showNotification: false,
      isShowCallback: true,
      subtitle: 'Video call',
      callbackText: 'End call',
    ),
    missedCallNotification: const NotificationParams(
      showNotification: false,
      isShowCallback: false,
    ),
    duration: const Duration(hours: 3).inMilliseconds,
    // TODO
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
