import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/calls/calls_api.dart';
import 'package:kepleomax/core/network/apis/calls/calls_dtos.dart';
import 'package:kepleomax/core/network/websockets/models/rtc_models.dart';
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
  OfferUpdate? _cachedOffer;
  final _acceptCallController = StreamController<void>.broadcast();

  late UserRepository _userRepository;
  late RtcWebSocket _webSocket;
  late CallsApi _callsApi;

  bool _callEndedByCurrentUser = true;

  OfferUpdate? get cachedOffer => _cachedOffer;

  /// methods
  void subscribeOnEvents({
    required RtcWebSocket rtsWebSocket,
    required UserRepository userRepository,
    required CallsApi callsApi,
  }) {
    _userRepository = userRepository;
    _webSocket = rtsWebSocket;
    _callsApi = callsApi;

    _callEndsSub = _webSocket.endCallStream.listen((update) {
      CallsNotificationsService.instance.endCall(
        update.callId,
        byCurrentUser: false,
      );
    });

    _eventsSub = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event?.event != null) {
        _handleCallKitEvent(event!);
      }
    });
  }

  void setCallEndedNotByCurrentUser() {
    _callEndedByCurrentUser = false;
  }

  Future<void> registerNewCall(String callId, User otherUser) async {
    _cachedOffer = OfferUpdate(callId: callId, otherUserId: otherUser.id);

    await CallsNotificationsService.instance.registerNewCall(
      callId,
      otherUserName: otherUser.username,
    );
  }

  Future<void> _callIncomingEvent(OfferUpdate offerUpdate) async {
    if (mainNavigatorGlobalKey.currentState!.currentIs<CallPage>()) return;

    _cachedOffer = offerUpdate;

    final otherUser = await _userRepository.getUser(userId: offerUpdate.otherUserId);
    mainNavigatorGlobalKey.currentState!.push(
      CallPage(otherUser: otherUser, doCall: false),
    );
  }

  /// there is no way I can trigger Event.callAccept, so I call this method
  /// directly and it must be public
  Future<void> callAcceptEvent(OfferUpdate offerUpdate) async {
    _acceptCallController.add(null);

    _cachedOffer = offerUpdate;

    /// doesn't trigger any event
    await CallsNotificationsService.instance.setCallConnected(offerUpdate.callId);
  }

  Future<void> _callDeclineEvent(String callId) async {
    _cachedOffer = null;

    if (_callEndedByCurrentUser) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      _callsApi.endCall(id: callId, fcmToken: fcmToken).ignore();
    } else {
      _callEndedByCurrentUser = true;
    }

    if (mainNavigatorGlobalKey.currentState!.currentIs<CallPage>()) {
      mainNavigatorGlobalKey.currentState!.pop();
    }
  }

  Future<void> _callEndedEvent(String callId) async {
    print('KlmLog callEndedEvent, byCurrentUser: $_callEndedByCurrentUser');
    _cachedOffer = null;

    if (_callEndedByCurrentUser) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      _callsApi.endCall(id: callId, fcmToken: fcmToken).ignore();
    } else {
      _callEndedByCurrentUser = true;
    }

    if (mainNavigatorGlobalKey.currentState!.currentIs<CallPage>()) {
      mainNavigatorGlobalKey.currentState!.pop();
    }
  }

  Future<void> _handleCallKitEvent(CallEvent event) async {
    print('KlmLog callKitEvent: ${event.event}');
    final extra = event.body['extra'] as Map<dynamic, dynamic>;

    switch (event.event) {
      case Event.actionCallIncoming:
        await _callIncomingEvent(OfferUpdate.fromJson(extra));
        break;
      case Event.actionCallAccept:
        await callAcceptEvent(OfferUpdate.fromJson(extra));
        break;
      case Event.actionCallDecline:
        await _callDeclineEvent(_cachedOffer!.callId);
        break;
      case Event.actionCallEnded:
        await _callEndedEvent(_cachedOffer!.callId);
        break;

      default:
        break;
    }
  }

  void unsubscribeFromEvents() {
    _offersSub?.cancel();
    _eventsSub?.cancel();
    _callEndsSub?.cancel();
    _offersSub = null;
    _eventsSub = null;
    _callEndsSub = null;
  }

  void checkActiveCalls(UserRepository userRepository, CallsApi callsApi) {
    FlutterCallkitIncoming.activeCalls().then((calls) async {
      try {
        if (calls is List && calls.isNotEmpty) return;
        final activeCall = calls[0];

        if (activeCall['isAccepted'] == true) {
          final extra = activeCall['extra'] as Map<dynamic, dynamic>;
          final callId = extra['id'] as String;
          final res = await callsApi.getStatusOfCall(callId: callId);
          if (res.response.statusCode != 200) {
            logger.e(
              res.data.message ??
                  'Failed to get status, statusCode: ${res.response.statusCode}',
            );
          }

          if (res.data.status == CallStatus.active ||
              res.data.status == CallStatus.pending) {
            if (_cachedOffer == null) {
              await _callIncomingEvent(OfferUpdate.fromJson(extra));
            }
            _acceptCallController.add(null);
          } else {
            _cachedOffer = OfferUpdate.fromJson(extra);

            /// call is already ended
            CallsNotificationsService.instance
                .endCall(callId, byCurrentUser: false)
                .ignore();
          }
        }
      } catch (e, st) {
        logger.e(e, stackTrace: st);
      }
    });
  }

  Future<bool> hasAcceptedCall() async {
    final calls = await FlutterCallkitIncoming.activeCalls();

    return calls is List && calls.isNotEmpty && calls[0]['isAccepted'] == true;
  }

  Future<Map<dynamic, dynamic>?> getActiveCall() async {
    final calls = await FlutterCallkitIncoming.activeCalls();

    if (calls is List && calls.isNotEmpty) {
      return calls[0] as Map<dynamic, dynamic>;
    } else {
      return null;
    }
  }

  Stream<void> get acceptCallStream => _acceptCallController.stream;
}
