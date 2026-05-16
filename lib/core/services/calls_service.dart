import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/data/user_repository.dart';
import 'package:kepleomax/core/network/apis/calls/calls_api.dart';
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
    // if (await PeerConnectionControllerImpl.activeCallOtherUserId != null) {
    //   print('KlmLog activeCallOtherUserId != null, declineCall');
    //   unawaited(_callsApi.endCall(id: offerUpdate.callId));
    //   await CallsNotificationsService.instance.hideNotification(offerUpdate.callId);
    //   return;
    // }

    _cachedOffer = offerUpdate;

    /// TODO getUserFromCacheOrApi
    final otherUser = await _userRepository.getUser(userId: offerUpdate.otherUserId);
    mainNavigatorGlobalKey.currentState!.push(
      CallPage(otherUser: otherUser, doCall: false),
    );
  }

  void callEnded() {
    print('KlmLog callEnded');
    if (mainNavigatorGlobalKey.currentState!.lastIs<CallPage>()) {
      _callEndedByCurrentUser = false;
      mainNavigatorGlobalKey.currentState!.pop();
    }

    // /// it closes the page and CallBloc will call endCall()
    // mainNavigatorGlobalKey.currentState!.popIfType<CallPage>();
  }

  Future<void> acceptCall() async {
    print('KlmLog acceptCall');
    await CallsNotificationsService.instance.hideNotification(cachedOffer!.callId);

    _cachedOffer = null;
  }

  Future<void> endCall(String callId) async {
    print('KlmLog endCall, byCurrentUser: $_callEndedByCurrentUser');
    if (_callEndedByCurrentUser) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      unawaited(_callsApi.endCall(id: callId, fcmToken: fcmToken));
      await CallsNotificationsService.instance.hideNotification(callId);
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
      callEnded();
    });

    _eventsSub = FlutterCallkitIncoming.onEvent.listen(_handleCallKitEvent);
  }

  Future<void> _handleCallKitEvent(CallEvent? event) async {
    print(
      'KlmLog event: ${event?.event}, ignore: ${CallsNotificationsService.instance.ignoreEvents}',
    );
    if (event?.event == null || CallsNotificationsService.instance.ignoreEvents)
      return;

    switch (event!.event) {
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

  void checkActiveCalls(UserRepository userRepository) {
    FlutterCallkitIncoming.activeCalls().then((calls) async {
      if (calls is List && calls.isNotEmpty) {
        if (calls[0]['isAccepted'] == true) {
          final extra = calls[0]['extra'] as Map<dynamic, dynamic>;
          if (_cachedOffer == null) {
            await _incomingCallNavigate(OfferUpdate.fromJson(extra));
          }
          _acceptCallController.add(null);
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
