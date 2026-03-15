import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/di/dependencies_multi_provider.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/messages_web_socket.dart';
import 'package:kepleomax/core/services/notifications_service.dart';
import 'package:kepleomax/features/chats/bloc/chats_bloc.dart';

class MessengerScope extends StatefulWidget {
  const MessengerScope({required this.child, super.key});

  final Widget child;

  @override
  State<MessengerScope> createState() => _MessengerScopeState();
}

/// get repository from dependencies - not the best solution, but creating a bloc
/// will be redundant, we don't even need a state
class _MessengerScopeState extends State<MessengerScope> {
  bool _isScreenInit = false;
  late final Dependencies _dp;
  late final KlmWebSocket _klmWebSocket;
  late final MessengerWebSocket _messengerWebSocket;
  late final ConnectionRepository _connectionRepository;
  late final MessengerRepository _messengerRepository;

  /// callbacks
  @override
  void initState() {
    _dp = Dependencies.of(context);

    /// providers will be cleared on dispose automatically in DependenciesMultiProvider
    _klmWebSocket = _dp.klmWebSocketBuilder();
    _dp.provide<KlmWebSocket>(_klmWebSocket);
    _messengerWebSocket = _dp.messengerWebSocketBuilder();
    _dp.provide<MessengerWebSocket>(_messengerWebSocket);
    _connectionRepository = _dp.connectionRepositoryBuilder();
    _messengerRepository = _dp.messengerRepositoryBuilder();

    _connectionRepository.connect();
    NotificationService.instance.init().ignore();
    super.initState();
  }

  @override
  void dispose() {
    _connectionRepository.dispose();
    _messengerRepository.dispose();

    super.dispose();
  }

  void _onResume() {
    if (!_isScreenInit) {
      _isScreenInit = true;
      return;
    }
    if (!_connectionRepository.isConnected) {
      print('trying to connect on onResume');
      Future.delayed(const Duration(seconds: 1), () async {
        _connectionRepository.reconnect(onlyIfDisconnected: true);
        await Future<void>.delayed(const Duration(milliseconds: 500));
        _connectionRepository.reconnect(onlyIfDisconnected: true);
        await Future<void>.delayed(const Duration(milliseconds: 1500));
        _connectionRepository.reconnect(onlyIfDisconnected: true);
      });
    }
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return DependenciesMultiProvider(
      providers: {
        KlmWebSocket: _klmWebSocket,
        MessengerWebSocket: _messengerWebSocket,
        ConnectionRepository: _connectionRepository,
        MessengerRepository: _messengerRepository,
      },
      child: BlocProvider(
        create: (context) => ChatsBloc(
          messengerRepository: _messengerRepository,
          connectionRepository: _connectionRepository,
        ),
        child: FocusDetector(
          onForegroundGained: _onResume,
          onVisibilityGained: _onResume,
          child: widget.child,
        ),
      ),
    );
  }
}
