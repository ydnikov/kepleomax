import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/features/call/data/peer_connection_controller.dart';

abstract class CallsRepository {
  Future<void> doCall({
    required int toUserId,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  });

  Future<void> acceptCall({
    required int otherUserId,
    required RTCSessionDescription offer,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  });

  Future<void> dispose();
}

class CallsRepositoryImpl implements CallsRepository {
  CallsRepositoryImpl({
    required RtcWebSocket rtcWebSocket,
    required PeerConnectionController peerConnectionController,
  }) : _webSocket = rtcWebSocket,
       _peerConnection = peerConnectionController {
    _webSocket.candidatesStream.listen((candidate) {
      _peerConnection.addIceCandidate(candidate.candidate);
    });
  }

  final RtcWebSocket _webSocket;
  final PeerConnectionController _peerConnection;
  int? _doCallLastInstanceId;

  @override
  Future<void> doCall({
    required int toUserId,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  }) async {
    _doCallLastInstanceId = DateTime.now().millisecondsSinceEpoch;
    final currentInstanceId = _doCallLastInstanceId;

    final iceCandidates = <RTCIceCandidate>[];
    bool isRemoteDescriptionSet = false;
    await _peerConnection.init(
      onTrack: (track) {
        if (track.track.kind == 'video') {
          remoteRenderer.srcObject = track.streams[0];
        }
      },
      onIceCandidate: (candidate) {
        if (isRemoteDescriptionSet) {
          _webSocket.sendIceCandidate(candidate, toUserId);
        } else {
          iceCandidates.add(candidate);
        }
      },
    );

    await _peerConnection.addTracks(localRenderer.srcObject!);

    final offer = await _peerConnection.createOffer();
    _webSocket.sendOffer(offer, toUserId);

    final answer = await _webSocket.answersStream.first.timeout(
      AppConstants.callingTimeout,
    );
    if (!_peerConnection.isActive || _doCallLastInstanceId != currentInstanceId)
      return;

    await _peerConnection.setLocalDescription(offer);
    await _peerConnection.setRemoteDescription(answer.answer);
    isRemoteDescriptionSet = true;

    for (final candidate in iceCandidates) {
      _webSocket.sendIceCandidate(candidate, toUserId);
    }
  }

  @override
  Future<void> acceptCall({
    required int otherUserId,
    required RTCSessionDescription offer,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  }) async {
    await _peerConnection.init(
      onTrack: (track) {
        if (track.track.kind == 'video') {
          remoteRenderer.srcObject = track.streams[0];
        }
      },
      onIceCandidate: (candidate) =>
          _webSocket.sendIceCandidate(candidate, otherUserId),
    );

    await _peerConnection.addTracks(localRenderer.srcObject!);

    await _peerConnection.setRemoteDescription(offer);
    final answer = await _peerConnection.createAnswer();
    _webSocket.sendAnswer(answer, otherUserId);
    await _peerConnection.setLocalDescription(answer);
  }

  @override
  Future<void> dispose() async {
    await _peerConnection.dispose();
  }
}
