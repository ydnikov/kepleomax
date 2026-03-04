import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/flavor.dart';
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
       _rtcWebSocket = webRtcWebSocket,
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
    on<CallEventFlipCamera>(_onFlipCamera);
    on<CallEventToggleCamera>(_onToggleCamera);
    on<CallEventToggleMicrophone>(_onToggleMicrophone);
    on<_CallEventEmit>(_onEmit);
    on<_CallEventExit>(_onExit);

    _remoteCameraStatusSub = _rtcWebSocket.remoteCameraStatusStream.listen((
      isCameraOn,
    ) {
      _data = _data.copyWith(isRemoteCameraOn: isCameraOn);
      add(const _CallEventEmit());
    });

    _acceptCallSub = CallsService.instance.acceptCallStream.listen((_) {
      add(const CallEventAcceptCall());
    });

    CallsService.instance.hasAcceptedCall().then((has) {
      if (has) {
        add(const CallEventAcceptCall());
      }
    });
  }

  final CallsRepository _callsRepository;
  final RtcWebSocket _rtcWebSocket;

  late final StreamSubscription<void> _remoteCameraStatusSub;
  late final StreamSubscription<void> _acceptCallSub;

  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;
  late CallData _data = CallData.initial();

  Future<void> _onInit(CallEventInit event, Emitter<CallState> emit) async {
    _data = _data.copyWith(otherUser: event.otherUser);
    emit(CallStateBase(data: _data));

    if (event.doCall) add(CallEventCall(otherUser: event.otherUser));
  }

  Future<void> _onCall(CallEventCall event, Emitter<CallState> emit) async {
    try {
      _localRenderer = await _setUpLocalRenderer();
      _remoteRenderer = await _setUpRemoteRenderer();

      _data = _data.copyWith(localRenderer: _localRenderer);
      emit(CallStateBase(data: _data));

      await _callsRepository.doCall(
        toUserId: event.otherUser.id,
        localRenderer: _localRenderer!,
        remoteRenderer: _remoteRenderer!,
      );
      if (isClosed) return;

      _data = _data.copyWith(
        isCallAccepted: true,
        remoteRenderer: _remoteRenderer,
        callStartedTime: DateTime.now(),
      );
      emit(CallStateBase(data: _data));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      if (isClosed) return;
      add(const _CallEventExit());
    }
  }

  int _lastTimeAcceptCallCalled = 0;
  Future<void> _onAcceptCall(
    CallEventAcceptCall event,
    Emitter<CallState> emit,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeAcceptCallCalled + 1000 > now || flavor.isTesting) {
      return;
    }
    _lastTimeAcceptCallCalled = now;

    try {
      if (CallsService.instance.cachedOffer == null) {
        throw Exception('Trying to accept the call, but the offer is null');
      }

      _localRenderer = await _setUpLocalRenderer();
      _remoteRenderer = await _setUpRemoteRenderer();

      await _callsRepository.acceptCall(
        otherUserId: _data.otherUser.id,
        offer: CallsService.instance.cachedOffer!,
        localRenderer: _localRenderer!,
        remoteRenderer: _remoteRenderer!,
      );

      _data = _data.copyWith(
        isCallAccepted: true,
        localRenderer: _localRenderer,
        remoteRenderer: _remoteRenderer,
        callStartedTime: DateTime.now(),
      );
      emit(CallStateBase(data: _data));

      unawaited(CallsService.instance.callAccepted(_data.otherUser.id));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      if (isClosed) return;
      add(const _CallEventExit());
    }
  }

  Future<RTCVideoRenderer> _setUpLocalRenderer() async {
    final mediaStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'environment', // or user
      },
    });

    final renderer = RTCVideoRenderer();
    await renderer.initialize();
    renderer.srcObject = mediaStream;
    return renderer;
  }

  Future<RTCVideoRenderer> _setUpRemoteRenderer() async {
    final remoteRenderer = RTCVideoRenderer();
    await remoteRenderer.initialize();
    return remoteRenderer;
  }

  void _onToggleCamera(CallEventToggleCamera event, Emitter<CallState> emit) {
    _localRenderer!.srcObject!.getVideoTracks().forEach((track) {
      track.enabled = !track.enabled;
    });
    _rtcWebSocket.sentCameraStatus(!_data.isLocalCameraOn, _data.otherUser.id);
    _data = _data.copyWith(isLocalCameraOn: !_data.isLocalCameraOn);
    emit(CallStateBase(data: _data));
  }

  void _onToggleMicrophone(
    CallEventToggleMicrophone event,
    Emitter<CallState> emit,
  ) {
    _localRenderer!.srcObject!.getAudioTracks().forEach((track) {
      track.enabled = !track.enabled;
    });
    _data = _data.copyWith(isLocalMicrophoneOn: !_data.isLocalMicrophoneOn);
    emit(CallStateBase(data: _data));
  }

  void _onFlipCamera(CallEventFlipCamera event, Emitter<CallState> emit) {
    if (!_data.isLocalCameraOn) return;

    Helper.switchCamera(_localRenderer!.srcObject!.getVideoTracks()[0]);
  }

  void _onEmit(_CallEventEmit event, Emitter<CallState> emit) {
    emit(CallStateBase(data: _data));
  }

  void _onExit(_CallEventExit event, Emitter<CallState> emit) {
    print('KlmLog onExit');
    emit(const CallStateExit());
    emit(CallStateBase(data: _data));
  }

  @override
  Future<void> close() {
    print('KlmLog CallBloc close');
    _remoteCameraStatusSub.cancel();
    _acceptCallSub.cancel();

    _callsRepository.disposeConnection().ignore();

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

    CallsService.instance.endCall(
      _data.otherUser.id,
      isCallAccepted: _data.isCallAccepted,
    );

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

class CallEventToggleCamera implements CallEvent {
  const CallEventToggleCamera();
}

class CallEventToggleMicrophone implements CallEvent {
  const CallEventToggleMicrophone();
}

class CallEventFlipCamera implements CallEvent {
  const CallEventFlipCamera();
}

class _CallEventExit implements CallEvent {
  const _CallEventExit();
}

class _CallEventEmit implements CallEvent {
  const _CallEventEmit();
}
