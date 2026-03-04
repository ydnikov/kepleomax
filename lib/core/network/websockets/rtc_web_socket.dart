import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/webrtc_models.dart';

class RtcWebSocket {
  RtcWebSocket({required KlmWebSocket klmWebSocket}) : _webSocket = klmWebSocket {
    _webSocket.eventsStream.listen((event) {
      final data = event.$2 as Map<String, dynamic>;
      switch (event.$1) {
        case 'webrtc_offer':
          _offersController.add(OfferUpdate.fromJson(data));
          break;

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

  final _offersController = StreamController<OfferUpdate>.broadcast();
  final _answersController = StreamController<AnswerUpdate>.broadcast();
  final _candidatesController = StreamController<CandidateUpdate>.broadcast();
  final _endCallController = StreamController<EndCallUpdate>.broadcast();
  final _remoteCameraStatusController = StreamController<bool>.broadcast();

  void sendOffer(RTCSessionDescription offer, int toUserId) {
    _webSocket.emit('webrtc_send_offer', {
      'to_user_id': toUserId,
      'offer': offer.toMap(),
    });
  }

  void sendAnswer(RTCSessionDescription answer, int toUserId) {
    _webSocket.emit('webrtc_send_answer', {
      'to_user_id': toUserId,
      'answer': answer.toMap(),
    });
  }

  void sendIceCandidate(RTCIceCandidate candidate, int toUserId) {
    _webSocket.emit('webrtc_send_ice_candidate', {
      'to_user_id': toUserId,
      'candidate': candidate.toMap(),
    });
  }

  void sentCameraStatus(bool isCameraOn, int toUserId) {
    _webSocket.emit('webrtc_send_camera_status', {
      'to_user_id': toUserId,
      'is_camera_on': isCameraOn,
    });
  }

  void endCall(int toUserId) {
    _webSocket.emit('webrtc_end_call', {'to_user_id': toUserId});
  }

  void sendMissedCallNotification(int toUserId) {
    _webSocket.emit('webrtc_send_missed_call_notification', {
      'to_user_id': toUserId,
    });
  }

  Stream<OfferUpdate> get offersStream => _offersController.stream;

  Stream<AnswerUpdate> get answersStream => _answersController.stream;

  Stream<CandidateUpdate> get candidatesStream => _candidatesController.stream;

  Stream<EndCallUpdate> get endCallStream => _endCallController.stream;

  Stream<bool> get remoteCameraStatusStream => _remoteCameraStatusController.stream;
}
