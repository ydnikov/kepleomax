import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class PeerConnectionController {
  Future<void> init({
    required void Function(RTCTrackEvent) onTrack,
    required void Function(RTCIceCandidate) onIceCandidate,
  });

  Future<RTCSessionDescription> createOffer();

  Future<RTCSessionDescription> createAnswer();

  void addIceCandidate(RTCIceCandidate candidate);

  Future<void> setLocalDescription(RTCSessionDescription desc);

  Future<void> setRemoteDescription(RTCSessionDescription desc);

  Future<void> addTracks(MediaStream mediaStream);

  Future<void> dispose();

  bool get isActive;
}

class PeerConnectionControllerImpl implements PeerConnectionController {
  RTCPeerConnection? _peerConnection;

  @override
  Future<void> init({
    required void Function(RTCTrackEvent) onTrack,
    required void Function(RTCIceCandidate) onIceCandidate,
  }) async {
    if (_peerConnection != null) {
      await dispose();
    }

    final config = {
      'sdpSemantics': 'unified-plan',
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    _peerConnection = await createPeerConnection(config);

    _peerConnection!.onTrack = (track) async {
      print('KlmLog newTrack: ${track.track.kind}');
      onTrack(track);
    };
    _peerConnection!.onIceCandidate = onIceCandidate;

    if (_candidatesCache.isNotEmpty) {
      _candidatesCache
        ..forEach(_peerConnection!.addCandidate)
        ..clear();
    }

    /// DEBUG
    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      print('KlmLog RTCPeerConnectionState: $state');
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      print('KlmLog RTCIceConnectionState: $state');
    };
  }

  @override
  Future<RTCSessionDescription> createOffer() => _peerConnection!.createOffer();

  @override
  Future<void> addTracks(MediaStream mediaStream) async {
    for (final track in mediaStream.getTracks()) {
      await _peerConnection!.addTrack(track, mediaStream);
    }
  }

  @override
  Future<void> dispose() async {
    await _peerConnection!.close();
    await _peerConnection!.dispose();
    _peerConnection = null;
  }

  List<RTCIceCandidate> _candidatesCache = [];

  @override
  void addIceCandidate(RTCIceCandidate candidate) {
    if (_peerConnection != null) {
      _peerConnection!.addCandidate(candidate);
    } else {
      _candidatesCache.add(candidate);
    }
  }

  @override
  Future<RTCSessionDescription> createAnswer() => _peerConnection!.createAnswer();

  @override
  Future<void> setLocalDescription(RTCSessionDescription desc) =>
      _peerConnection!.setLocalDescription(desc);

  @override
  Future<void> setRemoteDescription(RTCSessionDescription desc) async =>
      _peerConnection!.setRemoteDescription(desc);

  @override
  bool get isActive => _peerConnection != null;
}
