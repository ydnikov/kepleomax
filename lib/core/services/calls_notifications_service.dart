import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';

class CallsNotificationsService {
  CallsNotificationsService._();

  static final CallsNotificationsService _instance = CallsNotificationsService._();

  static CallsNotificationsService get instance => _instance;

  static const _ignoreEventsDuration = Duration(seconds: 1);

  bool _ignoreEvents = false;

  bool get ignoreEvents => _ignoreEvents;

  Future<void> showIncomingCall({
    required UserDto otherUser,
    RTCSessionDescription? offer,
  }) async {
    final params = _generateCallKitParams(otherUser, offer: offer);
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> hideNotification(String callId) async {
    _ignoreEvents = true;

    await FlutterCallkitIncoming.endCall(callId);

    await Future<void>.delayed(_ignoreEventsDuration);
    _ignoreEvents = false;
  }

  Future<void> showMissedCall({required UserDto otherUser}) async {
    _ignoreEvents = true;

    await FlutterCallkitIncoming.endCall(otherUser.id.toString());
    final params = _generateCallKitParams(otherUser);
    await FlutterCallkitIncoming.showMissCallNotification(params);

    await Future<void>.delayed(_ignoreEventsDuration);
    _ignoreEvents = false;
  }

  CallKitParams _generateCallKitParams(
    UserDto otherUser, {
    RTCSessionDescription? offer,
  }) => CallKitParams(
    id: otherUser.id.toString(),
    nameCaller: otherUser.username,
    appName: 'KepLeoMax',
    avatar: otherUser.profileImage,
    type: 0,
    textAccept: 'Accept',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    callingNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Calling...',
      callbackText: 'Hang Up',
    ),
    duration: AppConstants.callingTimeout.inMilliseconds,
    extra: offer == null
        ? <String, dynamic>{'other_user_id': otherUser.id}
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
