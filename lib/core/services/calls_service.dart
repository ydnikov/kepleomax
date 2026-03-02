import 'dart:async';

import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';

class CallsService {
  CallsService._();

  static final CallsService _instance = CallsService._();

  static CallsService get instance => _instance;

  StreamSubscription<void>? _offersSub;
  StreamSubscription<void>? _eventsSub;

  late UserRepository _userRepository;
  late RtcWebSocket _webSocket;

  void subscribeOnEvents(RtcWebSocket webSocket, UserRepository userRepository) {
    print('KlmLog subscribeOnEvents');

    _userRepository = userRepository;
    _webSocket = webSocket;

    _offersSub = _webSocket.offersStream.listen((offerUpdate) {
      _openCallPage({
        'other_user_id': offerUpdate.otherUserId,
        'offer_sdp': offerUpdate.offer.sdp,
        'offer_type': offerUpdate.offer.type,
      }, _userRepository);
    });

    /// FlutterCallkitIncoming.onEvent can be listen only in one place
    _eventsSub = FlutterCallkitIncoming.onEvent.listen(_handleCallKitEvents);
  }

  void _handleCallKitEvents(CallEvent? event) {
    print('KlmLog event: ${event?.event}');
    if (event?.event == null) return;

    switch (event!.event) {
      case Event.actionCallAccept:
        _openCallPage(
          event.body['extra'] as Map<dynamic, dynamic>,
          _userRepository,
        );
        break;
      case Event.actionCallDecline:
        _webSocket.endCall(
          event.body['extra']['other_user_id'] as int,
          markCallAsMissed: false,
        );
        _closeCallPage();
        break;
      default:
        break;
    }
    for (final callback in _additionListeners.values) {
      callback(event.event);
    }
  }

  /// don't need to cancel manually, will be cleared in unsubscribeFromEvents
  final _additionListeners = <int, void Function(Event)>{};

  void listen(int subscriberId, void Function(Event) callback) {
    _additionListeners[subscriberId] = callback;
  }

  void stopListening(int subscriberId) {
    _additionListeners.remove(subscriberId);
  }

  void unsubscribeFromEvents() {
    print('KlmLog unsubscribeFromEvents');

    _additionListeners.clear();
    _offersSub?.cancel();
    _eventsSub?.cancel();
    _offersSub = null;
    _eventsSub = null;
  }

  void checkActiveCalls(UserRepository userRepository) {
    FlutterCallkitIncoming.activeCalls().then((calls) {
      if (calls is List && calls.isNotEmpty) {
        if (calls[0]['isAccepted'] == true) {
          _openCallPage(calls[0]['extra'] as Map<dynamic, dynamic>, userRepository);
        }
      }
    });
  }

  Future<void> showIncomingCall({
    required UserDto otherUser,
    RTCSessionDescription? offer,
  }) async {
    final params = _generateCallKitParams(otherUser, offer: offer);
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endCall(String id) async {
    await FlutterCallkitIncoming.endCall(id);
  }

  Future<void> markCallAsMissed({required UserDto otherUser}) async {
    await FlutterCallkitIncoming.endCall(otherUser.id.toString());
    await FlutterCallkitIncoming.showMissCallNotification(
      _generateCallKitParams(otherUser),
    );
    return;

    // final activeCalls = await FlutterCallkitIncoming.activeCalls();
    // if (activeCalls is List && activeCalls.isNotEmpty) {
    //   final call = activeCalls.first;
    //   final isAccepted = (call['isAccepted'] as bool?) ?? false;
    //   final id = call['id'];
    //
    //   print('KlmLog markCallAsMissed, id: $id, isAccepted: $isAccepted');
    //
    //   if (id == otherUser.id.toString() && !isAccepted) {
    //     await FlutterCallkitIncoming.endCall(otherUser.id.toString());
    //     await FlutterCallkitIncoming.showMissCallNotification(
    //       _generateCallKitParams(otherUser),
    //     );
    //   }
    // }
  }

  Future<void> hideCall(String id) async {
    await _eventsSub?.cancel();
    await FlutterCallkitIncoming.endCall(id);
    await Future<void>.delayed(const Duration(seconds: 1));
    _eventsSub = FlutterCallkitIncoming.onEvent.listen(_handleCallKitEvents);
  }

  CallKitParams _generateCallKitParams(UserDto otherUser, {
    RTCSessionDescription? offer,
  }) =>
      CallKitParams(
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

  /// navigation
  Future<void> _openCallPage(Map<dynamic, dynamic> extra,
      UserRepository userRepository,) async {
    final otherUser = await userRepository.getUser(
      userId: extra['other_user_id'] as int,
    );
    mainNavigatorGlobalKey.currentState!.push(
      CallPage(
        otherUser: otherUser,
        doCall: false,
        offer: (extra['offer_sdp'] != null || extra['offer_type'] != null)
            ? RTCSessionDescription(
          extra['offer_sdp'] as String?,
          extra['offer_type'] as String?,
        )
            : null,
      ),
    );
  }

  void _closeCallPage() {
    mainNavigatorGlobalKey.currentState!.popIfType<CallPage>();
  }
}
