import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/services/notifications_service.dart';

class ConnectionScope extends StatefulWidget {
  const ConnectionScope({required this.child, super.key});

  final Widget child;

  @override
  State<ConnectionScope> createState() => _ConnectionScopeState();
}

/// get repository from dependencies - not the best solution, but creating a bloc
/// will be redundant, we don't even need a state
class _ConnectionScopeState extends State<ConnectionScope> {
  bool _isScreenInited = false;
  late final ConnectionRepository _repository;

  /// callbacks
  @override
  void initState() {
    _repository = Dependencies.of(context).connectionRepository;
    _repository.initSocket();
    NotificationService.instance.init().ignore();
    super.initState();
  }

  @override
  void dispose() {
    _repository.disconnect();
    super.dispose();
  }

  void _onResume() {
    if (!_isScreenInited) {
      _isScreenInited = true;
      return;
    }
    if (!_repository.isConnected) {
      print('KlmLog chatScope trying to connect on onResume');
      Future.delayed(const Duration(seconds: 1), () async {
        /// call it at least 3 times for sure. 1 time not always working on physical device
        _repository.reconnect(onlyIfDisconnected: true);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _repository.reconnect(onlyIfDisconnected: true);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _repository.reconnect(onlyIfDisconnected: true);
      });
    }
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: _onResume,
      onVisibilityGained: _onResume,
      child: widget.child,
    );
  }
}
