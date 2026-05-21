import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/logger.dart';
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

  /// main methods
  Future<void> _incomingCallNavigate(OfferUpdate offerUpdate) async {
    print('KlmLog incomingCallNavigate');

    _cachedOffer = offerUpdate;

    if (mainNavigatorGlobalKey.currentState!.currentIs<CallPage>()) return;

    // TODO getUserFromCacheOrApi
    final otherUser = await _userRepository.getUser(userId: offerUpdate.otherUserId);
    mainNavigatorGlobalKey.currentState!.push(
      CallPage(otherUser: otherUser, doCall: false),
    );
  }

  void callEnded(String callId) {
    print('KlmLog callEnded');
    if (mainNavigatorGlobalKey.currentState!.currentIs<CallPage>()) {
      _callEndedByCurrentUser = false;
      mainNavigatorGlobalKey.currentState!.pop();
    }

    _cachedOffer = null;
    CallsNotificationsService.instance.endCall(callId);
  }

  Future<void> acceptCall() async {
    print('KlmLog acceptCall');
    await CallsNotificationsService.instance.setCallConnected(cachedOffer!.callId);

    _cachedOffer = null;
  }

  Future<void> endCall(String callId) async {
    print('KlmLog endCall, byCurrentUser: $_callEndedByCurrentUser');
    await CallsNotificationsService.instance.endCall(callId);

    if (_callEndedByCurrentUser) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      _callsApi.endCall(id: callId, fcmToken: fcmToken).ignore();
    } else {
      _callEndedByCurrentUser = true; // reset to default
    }

    _cachedOffer = null;
  }

  Stream<void> get acceptCallStream => _acceptCallController.stream;

  /// other
  void subscribeOnEvents({
    required RtcWebSocket rtsWebSocket,
    required UserRepository userRepository,
    required CallsApi callsApi,
  }) {
    _userRepository = userRepository;
    _webSocket = rtsWebSocket;
    _callsApi = callsApi;

    _callEndsSub = _webSocket.endCallStream.listen((update) {
      callEnded(update.callId);
    });

    _eventsSub = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event?.event != null) {
        _handleCallKitEvent(event!);
      }
    });
  }

  Future<void> _handleCallKitEvent(CallEvent event) async {
    if (CallsNotificationsService.instance.ignoreEventsAndReset) {
      print('KlmLog CallKitIncoming ignore event: ${event.event}');
      return;
    } else {
      print('KlmLog CallKitIncoming event: ${event.event}');
    }

    switch (event.event) {
      case Event.actionCallIncoming:
        final extra = event.body['extra'] as Map<dynamic, dynamic>;
        await _incomingCallNavigate(OfferUpdate.fromJson(extra));
        break;
      case Event.actionCallAccept:
        final extra = event.body['extra'] as Map<dynamic, dynamic>;
        if (_cachedOffer == null) {
          await _incomingCallNavigate(OfferUpdate.fromJson(extra));
        }
        _acceptCallController.add(null);
        break;
      case Event.actionCallDecline:
        mainNavigatorGlobalKey.currentState!.popIfType<CallPage>();
        // endCall(event.body['extra']['other_user_id'] as int, isCallAccepted: false);
        break;
      case Event.actionCallEnded:
        if (mainNavigatorGlobalKey.currentState!.currentIs<CallPage>()) {
          mainNavigatorGlobalKey.currentState!.pop();
        } else {
          final extra = event.body['extra'] as Map<dynamic, dynamic>;
          print('extra: $extra');
          await CallsService.instance.endCall(extra['id'] as String);
        }
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
      if (calls is List && calls.isNotEmpty) {
        final activeCall = calls[0];

        if (activeCall['isAccepted'] == true) {
          final extra = calls[0]['extra'] as Map<dynamic, dynamic>;
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
              await _incomingCallNavigate(OfferUpdate.fromJson(extra));
            }
            _acceptCallController.add(null);
          } else {
            CallsNotificationsService.instance.endCall(callId).ignore();
          }
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
