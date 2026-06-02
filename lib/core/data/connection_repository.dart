import 'dart:async';

import 'package:kepleomax/core/di/disposable.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';

/// TODO rename, maybe baseWsRepository
abstract class ConnectionRepository implements Disposable {
  Future<void> connect();

  void reconnect({bool onlyIfDisconnected = false});

  void activityDetected();

  Stream<bool> get connectionStateStream;

  bool get isConnected;
}

class ConnectionRepositoryImpl implements ConnectionRepository {
  ConnectionRepositoryImpl({required KlmWebSocket klmWebSocket})
    : _webSocket = klmWebSocket;

  final KlmWebSocket _webSocket;

  /// callbacks
  @override
  Future<void> connect() => _webSocket.init();

  @override
  void dispose() => _webSocket.dispose();

  @override
  Future<void> reconnect({bool onlyIfDisconnected = false}) async =>
      onlyIfDisconnected ? _webSocket.connectIfNot() : await _webSocket.init();

  /// emits
  @override
  void activityDetected() {
    _webSocket.emit('activity_detected');
  }

  /// events
  @override
  bool get isConnected => _webSocket.isConnected;

  @override
  Stream<bool> get connectionStateStream => _webSocket.connectionStateStream;
}
