import 'dart:async';

import 'package:kepleomax/core/network/websockets/models/rtc_models.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:webrtc_interface/src/rtc_ice_candidate.dart';
import 'package:webrtc_interface/src/rtc_session_description.dart';

class MockRtcWebSocket implements RtcWebSocket {
  @override
  void sendOffer(RTCSessionDescription offer, int toUserId) {}

  @override
  void sendAnswer(RTCSessionDescription answer, int toUserId) {}

  @override
  void sendIceCandidate(RTCIceCandidate candidate, int toUserId) {}

  @override
  void sendCameraStatus(bool isCameraOn, int toUserId) {}

  @override
  void endCall(int toUserId) {}

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
  Stream<bool> get remoteCameraStatusStream =>
      StreamController<bool>.broadcast().stream;
}
