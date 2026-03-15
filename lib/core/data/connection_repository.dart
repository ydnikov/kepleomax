import 'dart:async';

import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';

/// TODO rename, maybe baseWsRepository
abstract class ConnectionRepository {
  Future<void> connect();

  Future<void> dispose();

  void reconnect({bool onlyIfDisconnected = false});

  void listenOnlineStatusUpdate({required int userId});

  void listenOnlineStatusUpdates({required List<int> usersIds});

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
  Future<void> dispose() => _webSocket.dispose();

  @override
  Future<void> reconnect({bool onlyIfDisconnected = false}) async =>
      onlyIfDisconnected ? _webSocket.connectIfNot() : await _webSocket.init();

  /// emits
  @override
  void listenOnlineStatusUpdates({required List<int> usersIds}) => _webSocket.emit(
    'subscribe_on_online_status_updates',
    {'users_ids': usersIds.toList()},
  );

  @override
  void listenOnlineStatusUpdate({required int userId}) =>
      _webSocket.emit('subscribe_on_online_status_updates', {
        'users_ids': [userId].toList(),
      });

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
