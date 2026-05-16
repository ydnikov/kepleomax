import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/rtc_models.dart';
import 'package:kepleomax/features/call/bloc/call_state.dart';

abstract class RtcWebSocket {
  /// actions
  void sendOffer(RTCSessionDescription offer, String callId);

  void sendAnswer(RTCSessionDescription answer, {required String callId});

  void sendIceCandidate(RTCIceCandidate candidate, String callId);

  void sendCameraStatus(CameraStatus status, String callId);

  Future<void> dispose();

  /// streams
  Stream<AnswerUpdate> get answersStream;

  Stream<CandidateUpdate> get candidatesStream;

  Stream<EndCallUpdate> get endCallStream;

  Stream<CameraStatusUpdate> get remoteCameraStatusStream;
}

class RtcWebSocketImpl implements RtcWebSocket {
  RtcWebSocketImpl({required KlmWebSocket klmWebSocket})
    : _webSocket = klmWebSocket {
    _eventsSub = _webSocket.eventsStream.listen((event) {
      final data = event.$2 as Map<String, dynamic>;
      switch (event.$1) {
        case 'webrtc_answer':
          _answersController.add(AnswerUpdate.fromJson(data));
          break;

        case 'webrtc_ice_candidate':
          _candidatesController.add(CandidateUpdate.fromJson(data));
          break;

        case 'webrtc_camera_status':
          _remoteCameraStatusController.add(CameraStatusUpdate.fromJson(data));
          break;

        case 'webrtc_end_call':
          _endCallController.add(EndCallUpdate.fromJson(data));
          break;
      }
    });
  }

  late final StreamSubscription<void> _eventsSub;
  final KlmWebSocket _webSocket;

  final _answersController = StreamController<AnswerUpdate>.broadcast();
  final _candidatesController = StreamController<CandidateUpdate>.broadcast();
  final _endCallController = StreamController<EndCallUpdate>.broadcast();
  final _remoteCameraStatusController =
      StreamController<CameraStatusUpdate>.broadcast();

  @override
  void sendOffer(RTCSessionDescription offer, String callId) {
    _webSocket.emit('webrtc_send_offer', {
      'call_id': callId,
      'offer': offer.toMap(),
    });
  }

  @override
  void sendAnswer(RTCSessionDescription answer, {required String callId}) {
    _webSocket.emit('webrtc_send_answer', {
      'call_id': callId,
      'answer': answer.toMap(),
    });
  }

  @override
  void sendIceCandidate(RTCIceCandidate candidate, String callId) {
    _webSocket.emit('webrtc_send_ice_candidate', {
      'call_id': callId,
      'candidate': candidate.toMap(),
    });
  }

  @override
  void sendCameraStatus(CameraStatus status, String callId) {
    _webSocket.emit('webrtc_send_camera_status', {
      'call_id': callId,
      'status': status.jsonName,
    });
  }

  @override
  Stream<AnswerUpdate> get answersStream => _answersController.stream;

  @override
  Stream<CandidateUpdate> get candidatesStream => _candidatesController.stream;

  @override
  Stream<EndCallUpdate> get endCallStream => _endCallController.stream;

  @override
  Stream<CameraStatusUpdate> get remoteCameraStatusStream =>
      _remoteCameraStatusController.stream;

  @override
  Future<void> dispose() async {
    await _eventsSub.cancel();
    await _answersController.close();
    await _candidatesController.close();
    await _endCallController.close();
    await _remoteCameraStatusController.close();
  }
}
