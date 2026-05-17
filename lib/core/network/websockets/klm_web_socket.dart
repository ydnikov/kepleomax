import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/network/token_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

abstract class KlmWebSocket {
  Future<void> init();

  void connectIfNot();

  void emit(String event, [dynamic data]);

  Future<void> dispose();

  bool get isConnected;

  Stream<bool> get connectionStateStream;

  Stream<(String, dynamic)> get eventsStream;
}

class KlmWebSocketImpl implements KlmWebSocket {
  KlmWebSocketImpl({required String baseUrl, required TokenProvider tokenProvider})
    : _baseUrl = baseUrl,
      _tokenProvider = tokenProvider;

  Socket? _socket;
  final String _baseUrl;
  final TokenProvider _tokenProvider;

  final StreamController<bool> _connectionController = StreamController.broadcast();
  final StreamController<(String, dynamic)> _eventsController =
      StreamController.broadcast();

  @override
  Future<void> init() async {
    logger.d('WebSocketLog! init, _socket != null: ${_socket != null}');
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }

    /// you can't pass auth data in OptionBuilder cause on reconnect it won't update
    /// for some reason (idk why)
    final accessToken = await _tokenProvider.getAccessToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();

    /// socket
    _socket = io(
      _baseUrl,
      OptionBuilder()
          .enableForceNew()
          .setAuth({'token': 'Bearer $accessToken', 'fcm_token': fcmToken})
          .enableAutoConnect()
          .setTransports(['websocket'])
          .build(),
    );

    /// events
    _socket!.onConnect((_) {
      logger.d('WebSocketLog Connected');
      _connectionController.add(true);
    });
    _socket!.onDisconnect((_) {
      logger.d('WebSocketLog Disconnected');
      if (!_connectionController.isClosed) {
        _connectionController.add(false);
      }
    });
    _socket!.onReconnect((_) async {
      logger.d('WebSocketLog Reconnect');
    });

    _socket!.onAny((name, data) {
      logger.d('WebSocketLog $name: $data');
      _eventsController.add((name, data));
    });

    /// errors events
    _socket!.onError((error) {
      logger.e('WebSocketLog error: $error');
    });
    _socket!.on('auth_error', (data) async {
      logger.d('WebSocketLog auth_error $data');
      if (data == 401) {
        final token = await _tokenProvider.getAccessToken();
        if (token == null) {
          logger.e('try to connect to ws, but no accessToken');
          _socket!.disconnect();
          return;
        }
        _socket!.disconnect();
        _socket!.auth = {'token': 'Bearer $token', 'fcm_token': fcmToken};
        _socket!.connect();
      }
    });
  }

  @override
  void connectIfNot() {
    logger.d(
      'WebSocketLog! connectIfNot, _socket != null: ${_socket != null}, _socket.disconnected: ${_socket?.disconnected}',
    );
    if (_socket?.disconnected == true) {
      _socket!.connect();
    }
  }

  @override
  Future<void> dispose() async {
    logger.d('WebSocketLog! disconnect, socket != null: ${_socket != null}');
    await _connectionController.close();
    await _eventsController.close();
    _socket?.dispose();
  }

  @override
  void emit(String event, [dynamic data]) {
    _socket?.emit(event, data);
  }

  @override
  bool get isConnected => _socket?.connected ?? false;

  /// streams
  @override
  Stream<bool> get connectionStateStream => _connectionController.stream;

  @override
  Stream<(String, dynamic)> get eventsStream => _eventsController.stream;
}
