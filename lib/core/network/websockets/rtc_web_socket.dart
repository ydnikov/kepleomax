import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/rtc_models.dart';

abstract class RtcWebSocket {
  /// actions
  void sendOffer(RTCSessionDescription offer, int toUserId);

  void sendAnswer(RTCSessionDescription answer, int toUserId);

  void sendIceCandidate(RTCIceCandidate candidate, int toUserId);

  void sendCameraStatus(bool isCameraOn, int toUserId);

  void endCall(int toUserId);

  /// streams
  Stream<AnswerUpdate> get answersStream;

  Stream<CandidateUpdate> get candidatesStream;

  Stream<EndCallUpdate> get endCallStream;

  Stream<bool> get remoteCameraStatusStream;
}

class RtcWebSocketImpl implements RtcWebSocket {
  RtcWebSocketImpl({required KlmWebSocket klmWebSocket})
    : _webSocket = klmWebSocket {
    _webSocket.eventsStream.listen((event) {
      final data = event.$2 as Map<String, dynamic>;
      switch (event.$1) {
        case 'webrtc_answer':
          _answersController.add(AnswerUpdate.fromJson(data));
          break;

        case 'webrtc_ice_candidate':
          _candidatesController.add(CandidateUpdate.fromJson(data));
          break;

        case 'webrtc_camera_status':
          _remoteCameraStatusController.add(data['is_camera_on'] as bool);
          break;

        case 'webrtc_end_call':
          _endCallController.add(EndCallUpdate.fromJson(data));
          break;
      }
    });
  }

  final KlmWebSocket _webSocket;

  final _answersController = StreamController<AnswerUpdate>.broadcast();
  final _candidatesController = StreamController<CandidateUpdate>.broadcast();
  final _endCallController = StreamController<EndCallUpdate>.broadcast();
  final _remoteCameraStatusController = StreamController<bool>.broadcast();

  @override
  void sendOffer(RTCSessionDescription offer, int toUserId) {
    _webSocket.emit('webrtc_send_offer', {
      'to_user_id': toUserId,
      'offer': offer.toMap(),
    });
  }

  @override
  void sendAnswer(RTCSessionDescription answer, int toUserId) {
    _webSocket.emit('webrtc_send_answer', {
      'to_user_id': toUserId,
      'answer': answer.toMap(),
    });
  }

  @override
  void sendIceCandidate(RTCIceCandidate candidate, int toUserId) {
    _webSocket.emit('webrtc_send_ice_candidate', {
      'to_user_id': toUserId,
      'candidate': candidate.toMap(),
    });
  }

  @override
  void sendCameraStatus(bool isCameraOn, int toUserId) {
    _webSocket.emit('webrtc_send_camera_status', {
      'to_user_id': toUserId,
      'is_camera_on': isCameraOn,
    });
  }

  @override
  void endCall(int toUserId) {
    _webSocket.emit('webrtc_end_call', {'to_user_id': toUserId});
  }

  @override
  Stream<AnswerUpdate> get answersStream => _answersController.stream;

  @override
  Stream<CandidateUpdate> get candidatesStream => _candidatesController.stream;

  @override
  Stream<EndCallUpdate> get endCallStream => _endCallController.stream;

  @override
  Stream<bool> get remoteCameraStatusStream => _remoteCameraStatusController.stream;
}
