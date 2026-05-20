import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/services/calls_notifications_service.dart';
import 'package:kepleomax/core/services/calls_service.dart';
import 'package:kepleomax/features/call/bloc/call_state.dart';
import 'package:kepleomax/features/call/data/calls_repository.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

const int _callWidth = 1280;
const int _callHeight = 720;

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc({
    required CallsRepository callsRepository,
    required RtcWebSocket rtcWebSocket,
  }) : _callsRepository = callsRepository,
       _rtcWebSocket = rtcWebSocket,
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
    on<CallEventOnPause>(_onPause);
    on<_CallEventEmit>(_onEmit);
    on<_CallEventExit>(_onExit);

    _remoteCameraStatusSub = _rtcWebSocket.remoteCameraStatusStream.listen((update) {
      if (update.callId != _data.callId) return;

      _data = _data.copyWith(remoteCameraStatus: update.status);
      add(const _CallEventEmit());
    });

    _connectionStatusSub = _callsRepository.connectionStream.listen((status) {
      _data = _data.copyWith(connectionStatus: status);
      add(const _CallEventEmit());

      if (status == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          status == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          status == RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
        add(const _CallEventExit());
      }
    });

    /// accept call can be called twice in a short time, so onAcceptCall has debouncer
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
  late final StreamSubscription<void> _connectionStatusSub;
  late final StreamSubscription<void> _acceptCallSub;

  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? _remoteRenderer;
  late CallData _data = CallData.initial();

  // /// used to restore state after turn on (cause off doesn't contains it was front or back)
  // CameraStatus _lastLocalCameraStatus = CameraStatus.back;

  Future<void> _onPause(CallEventOnPause event, Emitter<CallState> emit) async {
    if (_localRenderer == null) return;

    _localRenderer!.srcObject!.getVideoTracks().first.enabled = false;
    _localRenderer!.srcObject!.getAudioTracks().first.enabled = true;

    await WakelockPlus.enable();

    await Helper.setSpeakerphoneOn(true);

    print('CallBloc onPause');

    _data = _data.copyWith(localCameraStatus: CameraStatus.off);
    emit(CallStateBase(data: _data));
  }

  Future<void> _onInit(CallEventInit event, Emitter<CallState> emit) async {
    _data = _data.copyWith(
      otherUser: event.otherUser,
      callId: CallsService.instance.cachedOffer?.callId,
    );
    emit(CallStateBase(data: _data));

    if (event.doCall) add(CallEventCall(otherUser: event.otherUser));
  }

  Future<void> _onCall(CallEventCall event, Emitter<CallState> emit) async {
    try {
      _localRenderer = await _setUpLocalRenderer();
      _data = _data.copyWith(localRenderer: _localRenderer);
      emit(CallStateBase(data: _data));
      _remoteRenderer = await _setUpRemoteRenderer();

      final callId = await _callsRepository.createCall(
        otherUserId: event.otherUser.id,
      );
      _data = _data.copyWith(callId: callId);

      unawaited(
        CallsNotificationsService.instance.registerNewCall(
          callId,
          otherUserName: _data.otherUser.username,
        ),
      );

      await _callsRepository.doCall(
        callId: callId,
        otherUserId: event.otherUser.id,
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
    } on InitCallException catch (e, st) {
      logger.e(e, stackTrace: st);

      unawaited(
        Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG),
      );
      add(const _CallEventExit());
    } catch (e, st) {
      logger.e(e, stackTrace: st);

      // TODO make more accurate errors handling
      if (_localRenderer == null) {
        emit(const CallStateMessage(message: 'Access denied. Check permissions'));
        emit(CallStateBase(data: _data));
      }

      if (isClosed) return;
      add(const _CallEventExit());
    }
  }

  int _lastTimeAcceptCallCalled = 0;

  Future<void> _onAcceptCall(
    CallEventAcceptCall event,
    Emitter<CallState> emit,
  ) async {
    if (_data.isCallAccepted) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeAcceptCallCalled + 1000 > now || flavor.isTesting) {
      return;
    }
    _lastTimeAcceptCallCalled = now;

    _data = _data.copyWith(isCallAccepted: true);
    emit(CallStateBase(data: _data));

    try {
      if (CallsService.instance.cachedOffer == null) {
        throw Exception('Trying to accept the call, but the offer is null');
      }

      unawaited(CallsService.instance.acceptCall());

      _localRenderer = await _setUpLocalRenderer();
      _remoteRenderer = await _setUpRemoteRenderer();

      _data = _data.copyWith(
        localRenderer: _localRenderer,
        remoteRenderer: _remoteRenderer,
      );
      emit(CallStateBase(data: _data));

      final offer = await _callsRepository.getOffer(callId: _data.callId!);
      await _callsRepository.acceptCall(
        callId: _data.callId!,
        otherUserId: _data.otherUser.id,
        offer: offer,
        localRenderer: _localRenderer!,
        remoteRenderer: _remoteRenderer!,
      );

      _data = _data.copyWith(callStartedTime: DateTime.now());
      emit(CallStateBase(data: _data));
    } catch (e, st) {
      logger.e(e, stackTrace: st);

      if (_localRenderer == null) {
        emit(
          const CallStateMessage(message: 'Access denied. Check the permissions'),
        );
        emit(CallStateBase(data: _data));
      }

      if (isClosed) return;
      add(const _CallEventExit());
    }
  }

  Future<RTCVideoRenderer> _setUpLocalRenderer() async {
    final mediaStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user', 'width': _callWidth, 'height': _callHeight},
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
    final isCameraOn = _localRenderer!.srcObject!.getVideoTracks()[0].enabled;
    _localRenderer!.srcObject!.getVideoTracks()[0].enabled = !isCameraOn;

    final CameraStatus newStatus;
    if (isCameraOn) {
      newStatus = CameraStatus.off;
    } else {
      newStatus =
          _localRenderer!.srcObject!
                  .getVideoTracks()[0]
                  .getSettings()['facingMode'] ==
              'environment'
          ? CameraStatus.back
          : CameraStatus.front;
    }
    _rtcWebSocket.sendCameraStatus(newStatus, _data.callId!);
    _data = _data.copyWith(localCameraStatus: newStatus);

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

  Future<void> _onFlipCamera(
    CallEventFlipCamera event,
    Emitter<CallState> emit,
  ) async {
    if (_data.localCameraStatus.isOff) return;

    final isFront = await Helper.switchCamera(
      _localRenderer!.srcObject!.getVideoTracks()[0],
    );

    final newStatus = isFront ? CameraStatus.front : CameraStatus.back;
    _rtcWebSocket.sendCameraStatus(newStatus, _data.callId!);
    _data = _data.copyWith(localCameraStatus: newStatus);
    emit(CallStateBase(data: _data));
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
    _connectionStatusSub.cancel();
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

    if (_data.callId != null) {
      CallsService.instance.endCall(_data.callId!);
    } else {
      logger.i('close callBloc, _data.callId == null');
    }

    return super.close();
  }
}

@immutable
abstract class CallEvent {}

class CallEventInit implements CallEvent {
  const CallEventInit({required this.otherUser, required this.doCall});

  final User otherUser;
  final bool doCall;
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

class CallEventOnPause implements CallEvent {
  const CallEventOnPause();
}

class _CallEventExit implements CallEvent {
  const _CallEventExit();
}

class _CallEventEmit implements CallEvent {
  const _CallEventEmit();
}
