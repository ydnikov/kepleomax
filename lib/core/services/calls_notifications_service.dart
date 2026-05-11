import 'dart:async';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app_constants.dart';
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
    required UserDto otherUser,
    required DateTime startedAt,
    RTCSessionDescription? offer,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();

    final params = _generateCallKitParams(
      otherUser,
      startedAt: startedAt,
      offer: offer,
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> hideNotification(String callId) async {
    await _startIgnoringEvents();

    await FlutterCallkitIncoming.endCall(callId);

    unawaited(_waitAndStopIgnoringEvents());
  }

  // @Deprecated('Now missed call is made via new_message notification')
  // Future<void> showMissedCall({required UserDto otherUser}) async {
  //   await _startIgnoringEvents();
  //
  //   await FlutterCallkitIncoming.endCall(otherUser.id.toString());
  //   final params = _generateCallKitParams(otherUser);
  //   await FlutterCallkitIncoming.showMissCallNotification(params);
  //
  //   unawaited(_waitAndStopIgnoringEvents());
  // }

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
    UserDto otherUser, {
    required DateTime startedAt,
    RTCSessionDescription? offer,
  }) => CallKitParams(
    id: otherUser.id.toString(),
    nameCaller: otherUser.username,
    appName: 'KepLeoMax',
    avatar: otherUser.profileImage,
    type: 0,
    textAccept: 'Accept',
    textDecline: 'Decline',
    callingNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Calling...',
      callbackText: 'Hang Up',
    ),
    missedCallNotification: const NotificationParams(
      showNotification: false,
      isShowCallback: false,
    ),
    duration:
        AppConstants.callingTimeout.inMilliseconds -
        (DateTime.now().millisecondsSinceEpoch - startedAt.millisecondsSinceEpoch),
    extra: offer == null
        ? {'other_user_id': otherUser.id}
        : {
            'other_user_id': otherUser.id,
            'offer_sdp': offer.sdp,
            'offer_type': offer.type,
          },
    android: AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      logoUrl: otherUser.profileImage,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#2196F3',
      backgroundUrl: otherUser.profileImage,
      actionColor: '#4CAF50;',
      textColor: '#ffffff',
      incomingCallNotificationChannelName: 'Incoming Call',
      missedCallNotificationChannelName: 'Missed Call',
      isShowCallID: false,
    ),
  );
}
