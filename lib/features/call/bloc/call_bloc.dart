import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/services/calls_service.dart';
import 'package:kepleomax/features/call/bloc/call_state.dart';
import 'package:kepleomax/features/call/data/calls_repository.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc({
    required CallsRepository callsRepository,
    required RtcWebSocket webRtcWebSocket,
  }) : _callsRepository = callsRepository,
       _webRtcWebSocket = webRtcWebSocket,
       super(CallStateBase.initial()) {
    // on<CallEvent>(
    //   (event, emit) => switch (event) {
    //     final CallEventAcceptCall event => (event, emit),
    //     _ => null,
    //   },
    //   transformer: sequential(),
    // );
    on<CallEventInit>(_onInit);
    on<CallEventCall>(_onCall);
    on<CallEventAcceptCall>(_onAcceptCall);
    on<CallEventEndCall>(_onEndCall);
    on<CallEventFlipCamera>(_onFlipCamera);
    on<_CallEventEmit>(_onEmit);
    // on<_CallEventEmitStatus>(_onEmitStatus);

    _endCallSub = _webRtcWebSocket.endCallStream.listen((_) {
      print('KlmLog END CAlL IN CALL BLOC');
      _notifyOtherUserWhenClose = false;
      add(const CallEventEndCall());
    });

    FlutterCallkitIncoming.activeCalls().then((calls) {
      if (calls is List && calls.isNotEmpty) {
        if (calls[0]['isAccepted'] == true) {
          add(const CallEventAcceptCall());
        }
      }
    });

    CallsService.instance.listen(hashCode, (event) {
      if (isClosed) return;

      if (event == Event.actionCallAccept) {
        add(const CallEventAcceptCall());
      }
    });
    // _incomingCallsSub = FlutterCallkitIncoming.onEvent.listen((event) {
    //   switch (event?.event) {
    //     case Event.actionCallAccept:
    //       add(const CallEventAcceptCall());
    //       break;
    //
    //     // case Event.actionCallDecline:
    //     //   add(const CallEventEndCall());
    //     //   break;
    //
    //     default:
    //       break;
    //   }
    // });
  }

  final CallsRepository _callsRepository;
  final RtcWebSocket _webRtcWebSocket;

  bool _notifyOtherUserWhenClose = true;
  late StreamSubscription<void> _endCallSub;
  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;

  RTCSessionDescription? _cachedOffer;
  late CallData _data = CallData.initial();

  Future<void> _onInit(CallEventInit event, Emitter<CallState> emit) async {
    _cachedOffer = event.offer;
    _data = _data.copyWith(otherUser: event.otherUser);
    emit(CallStateBase(data: _data));

    if (event.doCall) add(CallEventCall(otherUser: event.otherUser));
  }

  Future<void> _onCall(CallEventCall event, Emitter<CallState> emit) async {
    try {
      CallsService.instance.stopListening(hashCode);

      _localRenderer = await _setUpLocalRenderer();
      _remoteRenderer = await _setUpRemoteRenderer();
      await _callsRepository.doCall(
        toUserId: event.otherUser.id,
        localRenderer: _localRenderer!,
        remoteRenderer: _remoteRenderer!,
      );
      if (isClosed) return;

      _data = _data.copyWith(
        isCallAccepted: true,
        localRenderer: _localRenderer,
        remoteRenderer: _remoteRenderer,
      );
      emit(CallStateBase(data: _data));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      if (isClosed) return;
      add(const CallEventEndCall());
    }
  }

  Future<void> _onAcceptCall(
    CallEventAcceptCall event,
    Emitter<CallState> emit,
  ) async {
    try {
      if (_cachedOffer == null) {
        throw Exception('Trying to accept the call, but the offer is null');
      }

      _localRenderer = await _setUpLocalRenderer();
      _remoteRenderer = await _setUpRemoteRenderer();
      await _callsRepository.acceptCall(
        otherUserId: _data.otherUser.id,
        offer: _cachedOffer!,
        localRenderer: _localRenderer!,
        remoteRenderer: _remoteRenderer!,
      );
      _cachedOffer = null;

      _data = _data.copyWith(
        isCallAccepted: true,
        localRenderer: _localRenderer,
        remoteRenderer: _remoteRenderer,
      );
      emit(CallStateBase(data: _data));

      unawaited(
        CallsService.instance.endCall(
          _data.otherUser.id.toString(),
        ),
      );
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      add(const CallEventEndCall());
    }
  }

  Future<RTCVideoRenderer> _setUpLocalRenderer() async {
    final localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'environment', // or user
      },
    });

    final renderer = RTCVideoRenderer();
    await renderer.initialize();
    renderer.srcObject = localStream;
    return renderer;
  }

  Future<RTCVideoRenderer> _setUpRemoteRenderer() async {
    final remoteRenderer = RTCVideoRenderer();
    await remoteRenderer.initialize();
    return remoteRenderer;
  }

  void _onFlipCamera(CallEventFlipCamera event, Emitter<CallState> emit) {
    Helper.switchCamera(_data.localRenderer!.srcObject!.getVideoTracks()[0]);
  }

  void _onEmit(_CallEventEmit event, Emitter<CallState> emit) {
    emit(CallStateBase(data: _data));
  }

  void _onEndCall(CallEventEndCall event, Emitter<CallState> emit) {
    print('KlmLog endCall');
    emit(const CallStateExit());
    emit(CallStateBase(data: _data));
  }

  @override
  Future<void> close() {
    print('KlmLog close');
    _endCallSub.cancel();

    if (_notifyOtherUserWhenClose) {
      _webRtcWebSocket.endCall(
        _data.otherUser.id,
        markCallAsMissed: !_data.isCallAccepted && _cachedOffer == null,
      );
    }
    _callsRepository.endCall().ignore();

    _localRenderer?.srcObject?.dispose();
    _localRenderer?.dispose();
    _remoteRenderer?.srcObject?.dispose();
    _remoteRenderer?.dispose();
    _localRenderer?.srcObject?.getTracks().forEach((track) {
      track
        ..enabled = false
        ..stop();
    });
    _remoteRenderer?.srcObject?.getTracks().forEach((track) {
      track
        ..enabled = false
        ..stop();
    });

    FlutterCallkitIncoming.endCall(_data.otherUser.id.toString());

    return super.close();
  }
}

@immutable
abstract class CallEvent {}

class CallEventInit implements CallEvent {
  const CallEventInit({required this.otherUser, required this.doCall, this.offer});

  final User otherUser;
  final bool doCall;
  final RTCSessionDescription? offer;
}

class CallEventCall implements CallEvent {
  const CallEventCall({required this.otherUser});

  final User otherUser;
}

class CallEventAcceptCall implements CallEvent {
  const CallEventAcceptCall();
}

class CallEventFlipCamera implements CallEvent {
  const CallEventFlipCamera();
}

class CallEventEndCall implements CallEvent {
  const CallEventEndCall();
}

class _CallEventEmit implements CallEvent {
  const _CallEventEmit();
}

// class _CallEventEmitStatus implements CallEvent {
//   _CallEventEmitStatus({required this.status});
//
//   final CallStatus status;
// }
