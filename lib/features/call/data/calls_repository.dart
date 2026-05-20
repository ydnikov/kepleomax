import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/network/apis/calls/calls_api.dart';
import 'package:kepleomax/core/network/apis/calls/calls_dtos.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/features/call/data/peer_connection_controller.dart';

abstract class CallsRepository {
  Future<String> createCall({required int otherUserId});

  Future<void> doCall({
    required String callId,
    required int otherUserId,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  });

  Future<void> acceptCall({
    required String callId,
    required int otherUserId,
    required RTCSessionDescription offer,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  });

  Future<RTCSessionDescription> getOffer({required String callId});

  Future<CallStatus> getStatus({required String callId});

  Future<List<RTCRtpSender>> getSenders();

  Future<void> removeTrack(RTCRtpSender sender);

  Future<void> disposeConnection();

  Stream<RTCPeerConnectionState> get connectionStream;
}

class CallsRepositoryImpl implements CallsRepository {
  CallsRepositoryImpl({
    required CallsApi callsApi,
    required RtcWebSocket rtcWebSocket,
    required PeerConnectionController peerConnectionController,
  }) : _callsApi = callsApi,
       _webSocket = rtcWebSocket,
       _peerConnection = peerConnectionController {
    _webSocket.candidatesStream.listen((candidate) {
      /// TODO check callId
      _peerConnection.addIceCandidate(candidate.candidate);
    });
  }

  final CallsApi _callsApi;
  final RtcWebSocket _webSocket;
  final PeerConnectionController _peerConnection;
  int? _doCallLastInstanceId;

  Future<String?> get _getFcmToken => FirebaseMessaging.instance.getToken();

  @override
  Future<String> createCall({required int otherUserId}) async {
    final fcmToken = await _getFcmToken;
    final result = await _callsApi.newCall(
      otherUserId: otherUserId,
      fcmToken: fcmToken!,
    );
    if (result.response.statusCode != 200) {
      throw InitCallException(
        result.data.message ??
            'Failed to init the new call: ${result.response.statusCode!}',
      );
    }

    return result.data.data!.callId;
  }

  @override
  Future<String> doCall({
    required String callId,
    required int otherUserId,
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
          _webSocket.sendIceCandidate(candidate, callId);
        } else {
          iceCandidates.add(candidate);
        }
      },
    );

    await _peerConnection.addTracks(localRenderer.srcObject!);

    final offer = await _peerConnection.createOffer();
    _webSocket.sendOffer(offer, callId);

    final answer = await _webSocket.answersStream
        .where((update) => update.callId == callId)
        .first
        .timeout(AppConstants.callingTimeout);
    if (!_peerConnection.isActive) {
      throw Exception('PeerConnection is no longer active');
    } else if (_doCallLastInstanceId != currentInstanceId) {
      disposeConnection().ignore();
      throw Exception('New call was made');
    }

    await _peerConnection.setLocalDescription(offer);
    await _peerConnection.setRemoteDescription(answer.answer);
    isRemoteDescriptionSet = true;

    for (final candidate in iceCandidates) {
      _webSocket.sendIceCandidate(candidate, callId);
    }

    return answer.callId;
  }

  @override
  Future<void> acceptCall({
    required String callId,
    required int otherUserId,
    required RTCSessionDescription offer,
    required RTCVideoRenderer localRenderer,
    required RTCVideoRenderer remoteRenderer,
  }) async {
    final fcmToken = await _getFcmToken;
    final response = await _callsApi.acceptCall(callId: callId, fcmToken: fcmToken!);
    if (response.response.statusCode != 200) {
      throw const InitCallException('Failed to accept the call');
    }

    await _peerConnection.init(
      onTrack: (track) {
        if (track.track.kind == 'video') {
          remoteRenderer.srcObject = track.streams[0];
        }
      },
      onIceCandidate: (candidate) {
        _webSocket.sendIceCandidate(candidate, callId);
      },
    );

    await _peerConnection.addTracks(localRenderer.srcObject!);

    await _peerConnection.setRemoteDescription(offer);
    final answer = await _peerConnection.createAnswer();
    _webSocket.sendAnswer(answer, callId: callId);
    await _peerConnection.setLocalDescription(answer);
  }

  @override
  Future<RTCSessionDescription> getOffer({required String callId}) async {
    final res = await _callsApi.getOffer(callId: callId);

    if (res.response.statusCode == 200) {
      final data = res.data.data;
      return RTCSessionDescription(data.sdp, data.type);
    }

    throw Exception('Failed to get offer, statusCode: ${res.response.statusCode}');
  }

  @override
  Future<CallStatus> getStatus({required String callId}) async {
    final res = await _callsApi.getStatusOfCall(callId: callId);

    if (res.response.statusCode == 200) {
      return res.data.status!;
    }

    throw Exception(
      res.data.message ??
          'Failed to get status, statusCode: ${res.response.statusCode}',
    );
  }

  @override
  Future<List<RTCRtpSender>> getSenders() => _peerConnection.getSenders();

  @override
  Future<void> removeTrack(RTCRtpSender sender) =>
      _peerConnection.removeTrack(sender);

  @override
  Future<void> disposeConnection() async {
    await _peerConnection.dispose();
  }

  @override
  Stream<RTCPeerConnectionState> get connectionStream =>
      _peerConnection.connectionStream;
}

class InitCallException implements Exception {
  const InitCallException(this.message);

  final String message;
}
