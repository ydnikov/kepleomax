import 'package:flutter_webrtc/flutter_webrtc.dart';

extension RtcSessionDescriptionFromJsonExtension on RTCSessionDescription {
  static RTCSessionDescription fromNotificationExtra(Map<dynamic, dynamic> json) {
    return RTCSessionDescription(
      json['offer_sdp'] as String?,
      json['offer_type'] as String?,
    );
  }
}
