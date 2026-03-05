import 'dart:async';

import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/extensions/rtc_session_description_extension.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/services/calls_notifications_service.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';

class CallsService {
  CallsService._();

  static final CallsService _instance = CallsService._();

  static CallsService get instance => _instance;

  StreamSubscription<void>? _offersSub;
  StreamSubscription<void>? _callEndsSub;
  StreamSubscription<void>? _eventsSub;
  RTCSessionDescription? _cachedOffer;
  final _acceptCallController = StreamController<void>.broadcast();

  late UserRepository _userRepository;
  late RtcWebSocket _webSocket;
  bool _hasActiveCall = false;

  /// main methods
  Future<void> _incomingCall(int otherUserId, RTCSessionDescription? offer) async {
    _hasActiveCall = true;
    _cachedOffer = offer;

    /// TODO getUserFromCacheOrApi
    final otherUser = await _userRepository.getUser(userId: otherUserId);
    mainNavigatorGlobalKey.currentState!.push(
      CallPage(otherUser: otherUser, doCall: false, offer: offer),
    );
  }

  Future<void> _incomingCallAndAccept(
    int otherUserId,
    RTCSessionDescription? offer,
  ) async {
    _hasActiveCall = true;
    if (_cachedOffer == null) {
      /// _webSocket.offersStream hasn't received event, app was not connected (like in background)
      await _incomingCall(otherUserId, offer);
    } else {
      /// app is connected (in foreground), call screen is already opened
    }

    _acceptCallController.add(null);
  }

  void _callEnded(int otherUserId) {
    /// it closes the page and CallBloc will call endCall()
    mainNavigatorGlobalKey.currentState!.popIfType<CallPage>();
  }

  Future<void> callAccepted(int otherUserId) async {
    _hasActiveCall = true;
    _cachedOffer = null;

    await CallsNotificationsService.instance.hideNotification(
      otherUserId.toString(),
    );
  }

  Future<void> endCall(int otherUserId, {required bool isCallAccepted}) async {
    _hasActiveCall = false;
    _cachedOffer = null;

    _webSocket.endCall(otherUserId);

    await CallsNotificationsService.instance.hideNotification(
      otherUserId.toString(),
    );
  }

  RTCSessionDescription? get cachedOffer => _cachedOffer;

  Stream<void> get acceptCallStream => _acceptCallController.stream;

  /// other
  void subscribeOnEvents(RtcWebSocket webSocket, UserRepository userRepository) {
    print('KlmLog subscribeOnEvents');

    _userRepository = userRepository;
    _webSocket = webSocket;

    _callEndsSub = _webSocket.endCallStream.listen((update) {
      _callEnded(update.fromUserId);
    });

    _eventsSub = FlutterCallkitIncoming.onEvent.listen(_handleCallKitEvents);
  }

  void _handleCallKitEvents(CallEvent? event) {
    print(
      'KlmLog event: ${event?.event}, ignore: ${CallsNotificationsService.instance.ignoreEvents}',
    );
    if (event?.event == null || CallsNotificationsService.instance.ignoreEvents)
      return;

    switch (event!.event) {
      case Event.actionCallIncoming:
        if (_hasActiveCall) {
          endCall(
            event.body['extra']['other_user_id'] as int,
            isCallAccepted: false,
          );
        }

        final extra = event.body['extra'] as Map<dynamic, dynamic>;
        final offer = RtcSessionDescriptionFromJsonExtension.fromNotificationExtra(
          extra,
        );
        _incomingCall(extra['other_user_id'] as int, offer);
        break;
      case Event.actionCallAccept:
        final extra = event.body['extra'] as Map<dynamic, dynamic>;
        final offer = RtcSessionDescriptionFromJsonExtension.fromNotificationExtra(
          extra,
        );
        _incomingCallAndAccept(extra['other_user_id'] as int, offer);
        break;
      case Event.actionCallDecline:
        endCall(event.body['extra']['other_user_id'] as int, isCallAccepted: false);
        break;

      default:
        break;
    }
  }

  void unsubscribeFromEvents() {
    print('KlmLog unsubscribeFromEvents');

    _offersSub?.cancel();
    _eventsSub?.cancel();
    _callEndsSub?.cancel();
    _offersSub = null;
    _eventsSub = null;
    _callEndsSub = null;
  }

  void checkActiveCalls(UserRepository userRepository) {
    FlutterCallkitIncoming.activeCalls().then((calls) {
      if (calls is List && calls.isNotEmpty) {
        if (calls[0]['isAccepted'] == true) {
          final extra = calls[0]['extra'] as Map<dynamic, dynamic>;
          final offer = RtcSessionDescriptionFromJsonExtension.fromNotificationExtra(
            extra,
          );
          _incomingCallAndAccept(extra['other_user_id'] as int, offer);
        }
      }
    });
  }

  Future<bool> hasAcceptedCall() async {
    final calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List && calls.isNotEmpty) {
      if (calls[0]['isAccepted'] == true) {
        return true;
      }
    }
    return false;
  }
}
