import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PeerConnectionController {
  Future<void> init({
    required int otherUserId,
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

  Stream<RTCPeerConnectionState> get connectionStream;
}

class PeerConnectionControllerImpl implements PeerConnectionController {
  PeerConnectionControllerImpl({required SharedPreferences prefs})
      : _prefs = prefs {
    _prefs.remove(_callOtherUserIdKey);
  }

  final SharedPreferences _prefs;

  RTCPeerConnection? _peerConnection;
  final List<RTCIceCandidate> _candidatesCache = [];
  final _connectionController = StreamController<RTCPeerConnectionState>.broadcast();

  static const _callOtherUserIdKey = '__call_other_user_id_key__';

  static Future<int?> get activeCallOtherUserId async =>
      (await SharedPreferences.getInstance()).getInt(_callOtherUserIdKey) ?? null;

  @override
  Future<void> init({
    required int otherUserId,
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
    unawaited(_prefs.setInt(_callOtherUserIdKey, otherUserId));

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
      _connectionController.add(state);
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
    unawaited(_prefs.remove(_callOtherUserIdKey));
    await _peerConnection!.close();
    await _peerConnection!.dispose();
    _peerConnection = null;
  }

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

  @override
  Stream<RTCPeerConnectionState> get connectionStream =>
      _connectionController.stream;
}
