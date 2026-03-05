import 'dart:async';

import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';

class MockKlmWebSocket implements KlmWebSocket {
  bool _isConnected = false;

  void setIsConnected(bool value) {
    _isConnected = value;
    _connectionController.add(value);
  }

  final StreamController<bool> _connectionController = StreamController.broadcast();
  final StreamController<(String, dynamic)> _eventsController =
      StreamController.broadcast();

  @override
  void connectIfNot() {}

  @override
  Stream<bool> get connectionStateStream => _connectionController.stream;

  @override
  void disconnect() {}

  @override
  void emit(String event, [data]) {}

  @override
  Stream<(String, dynamic)> get eventsStream => _eventsController.stream;

  @override
  Future<void> init() async {}

  @override
  bool get isConnected => _isConnected;
}
