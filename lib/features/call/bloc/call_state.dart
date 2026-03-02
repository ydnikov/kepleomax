import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/user.dart';

part 'call_state.freezed.dart';

abstract class CallState {}

@freezed
abstract class CallStateBase with _$CallStateBase implements CallState {
  const factory CallStateBase({required CallData data}) = _CallStateBase;

  factory CallStateBase.initial() => CallStateBase(data: CallData.initial());
}

@freezed
abstract class CallStateExit with _$CallStateExit implements CallState {
  const factory CallStateExit() = _CallStateExit;
}

@freezed
abstract class CallStateMessage with _$CallStateMessage implements CallState {
  const factory CallStateMessage({
    required String message,
    @Default(false) bool isError,
  }) = _CallStateMessage;
}

@freezed
abstract class CallData with _$CallData implements CallState {
  const factory CallData({
    required User otherUser,
    @Default(RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) RTCPeerConnectionState connectionState,
    RTCVideoRenderer? localRenderer,
    RTCVideoRenderer? remoteRenderer,
    DateTime? callStartedTime,
    @Default(true) bool isLocalCameraOn,
    @Default(true) bool isRemoteCameraOn,
    @Default(true) bool isLocalMicrophoneOn,
    @Default(false) bool isCallAccepted,
  }) = _CallData;

  factory CallData.initial() => CallData(
    otherUser: User.loading(),
    connectionState: RTCPeerConnectionState.RTCPeerConnectionStateClosed,
  );
}

// enum CallStatus {
//   waitingForResponse,
//   waitingForYourResponse,
//   cancelledDueToTimeout,
//   otherUserEndedCall,
//   accepted,
//   disconnected,
//   none,
// }