import 'package:flutter_webrtc/flutter_webrtc.dart';

class OfferUpdate {
  const OfferUpdate({
    required this.callId,
    required this.otherUserId,
    required this.offer,
  });

  factory OfferUpdate.fromJson(Map<dynamic, dynamic> json) => OfferUpdate(
    callId: json['id'] as String,
    otherUserId: json['other_user_id'] as int,
    offer: RTCSessionDescription(
      (json['offer_sdp'] as String?) ?? json['offer']['sdp'] as String?,
      (json['offer_type'] as String?) ?? json['offer']['type'] as String?,
    ),
  );

  final String callId;
  final int otherUserId;
  final RTCSessionDescription offer;
}

class AnswerUpdate {
  const AnswerUpdate({
    required this.callId,
    required this.otherUserId,
    required this.answer,
  });

  factory AnswerUpdate.fromJson(Map<String, dynamic> json) => AnswerUpdate(
    callId: json['id'] as String,
    otherUserId: json['other_user_id'] as int,
    answer: RTCSessionDescription(
      json['answer']['sdp'] as String?,
      json['answer']['type'] as String?,
    ),
  );

  final String callId;
  final int otherUserId;
  final RTCSessionDescription answer;
}

class CandidateUpdate {
  const CandidateUpdate({required this.otherUserId, required this.candidate});

  factory CandidateUpdate.fromJson(Map<String, dynamic> json) => CandidateUpdate(
    otherUserId: json['other_user_id'] as int,
    candidate: RTCIceCandidate(
      json['candidate']['candidate'] as String?,
      json['candidate']['sdpMid'] as String?,
      json['candidate']['sdpMLineIndex'] as int?,
    ),
  );

  final int otherUserId;
  final RTCIceCandidate candidate;
}

class EndCallUpdate {
  const EndCallUpdate({required this.fromUserId});

  factory EndCallUpdate.fromJson(Map<String, dynamic> json) =>
      EndCallUpdate(fromUserId: json['other_user_id'] as int);

  final int fromUserId;
}
