import 'dart:async';

import 'package:kepleomax/core/network/websockets/models/rtc_models.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/features/call/bloc/call_state.dart';
import 'package:webrtc_interface/src/rtc_ice_candidate.dart';
import 'package:webrtc_interface/src/rtc_session_description.dart';

class MockRtcWebSocket implements RtcWebSocket {
  @override
  void sendOffer(RTCSessionDescription offer, String callId) {}

  @override
  void sendAnswer(RTCSessionDescription answer, {required String callId}) {}

  @override
  void sendIceCandidate(RTCIceCandidate candidate, String callId) {}

  @override
  void sendCameraStatus(CameraStatus status, String callId) {}

  /// streams
  @override
  Stream<AnswerUpdate> get answersStream =>
      StreamController<AnswerUpdate>.broadcast().stream;

  @override
  Stream<CandidateUpdate> get candidatesStream =>
      StreamController<CandidateUpdate>.broadcast().stream;

  @override
  Stream<EndCallUpdate> get endCallStream =>
      StreamController<EndCallUpdate>.broadcast().stream;

  @override
  Stream<CameraStatusUpdate> get remoteCameraStatusStream =>
      StreamController<CameraStatusUpdate>.broadcast().stream;

  @override
  Future<void> dispose() async {}
}
