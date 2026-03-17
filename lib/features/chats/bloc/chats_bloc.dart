import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/data/messenger/messenger_repository.dart';
import 'package:kepleomax/core/data/models/chats_collection.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/features/chats/bloc/chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc({
    required MessengerRepository messengerRepository,
    required ConnectionRepository connectionRepository,
  }) : _messengerRepository = messengerRepository,
       _connectionRepository = connectionRepository,
       super(ChatsStateBase.initial()) {
    _subConnectionState = _connectionRepository.connectionStateStream.listen(
      (isConnected) => add(_ChatsEventConnectingChanged(isConnected)),
    );
    _chatsUpdatesSub = _messengerRepository.chatsUpdatesStream.listen(
      (newList) {
        add(_ChatsEventEmitChatsList(data: newList));
      },
      onError: (Object e, StackTrace st) {
        add(_ChatsEventEmitError(error: e, stackTrace: st));
      },
    );

    on<ChatsEvent>(
      (event, emit) => switch (event) {
        final ChatsEventLoadCache event => _onLoadCache(event, emit),
        final ChatsEventLoad event => _onLoad(event, emit),
        _ => null,
      },
      //transformer: sequential(),
    );

    on<ChatsEventReconnect>(_onReconnect);

    /// local events
    on<_ChatsEventConnectingChanged>(_onConnectingChanged);
    on<_ChatsEventEmitChatsList>(_onEmitChatsList);
    on<_ChatsEventEmitError>(_onEmitError);
  }

  final MessengerRepository _messengerRepository;
  final ConnectionRepository _connectionRepository;
  late ChatsData _data = ChatsData.initial();
  late final StreamSubscription<void> _chatsUpdatesSub;
  late final StreamSubscription<void> _subConnectionState;

  Future<void> _onLoadCache(
    ChatsEventLoadCache event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _messengerRepository.loadCachedChats();
    } catch (e, st) {
      if (isClosed) return;
      add(_ChatsEventEmitError(error: e, stackTrace: st));
    }
  }

  int _lastTimeLoadWasCalled = 0;

  Future<void> _onLoad(ChatsEventLoad event, Emitter<ChatsState> emit) async {
    /// TODO make this with bloc_concurrency, make isTesting better
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeLoadWasCalled + 1000 > now && !flavor.isTesting) {
      return;
    }
    _lastTimeLoadWasCalled = now;

    _data = _data.copyWith(isLoading: true);
    emit(ChatsStateBase(data: _data));

    try {
      await _messengerRepository.loadChats();
    } catch (e, st) {
      if (isClosed) return;
      add(_ChatsEventEmitError(error: e, stackTrace: st));
    }
  }

  Future<void> _onEmitChatsList(
    _ChatsEventEmitChatsList event,
    Emitter<ChatsState> emit,
  ) async {
    final data = event.data;

    /// cache can't replace api chats
    if (data.fromCache && !_data.isLoading) {
      return;
    }
    _data = _data.copyWith(
      chats: data.chats,
      totalUnreadCount: data.chats.fold(0, (a, b) => a + b.unreadCount),
      isLoading: data.fromCache,
    );
    emit(ChatsStateBase(data: _data));
  }

  void _onEmitError(_ChatsEventEmitError event, Emitter<ChatsState> emit) {
    logger.e(event.error, stackTrace: event.stackTrace);
    emit(ChatsStateMessage(message: event.error.userErrorMessage, isError: true));
    emit(ChatsStateBase(data: _data));
  }

  void _onReconnect(ChatsEventReconnect event, Emitter<ChatsState> emit) {
    _connectionRepository.reconnect(onlyIfDisconnected: event.onlyIfNot);
  }

  void _onConnectingChanged(
    _ChatsEventConnectingChanged event,
    Emitter<ChatsState> emit,
  ) {
    _data = _data.copyWith(isConnected: event.isConnected);
    if (event.isConnected) {
      add(const ChatsEventLoad());
    } else {
      emit(ChatsStateBase(data: _data));
    }
  }

  @override
  Future<void> close() {
    _chatsUpdatesSub.cancel();
    _subConnectionState.cancel();
    return super.close();
  }
}

///events
abstract class ChatsEvent {}

/// call it on initState. Load will be called on ws connected
class ChatsEventLoadCache implements ChatsEvent {
  const ChatsEventLoadCache();
}

class ChatsEventLoad implements ChatsEvent {
  const ChatsEventLoad();
}

class ChatsEventReconnect implements ChatsEvent {
  const ChatsEventReconnect({this.onlyIfNot = false});

  final bool onlyIfNot;
}

class _ChatsEventConnectingChanged implements ChatsEvent {
  const _ChatsEventConnectingChanged(this.isConnected);

  final bool isConnected;
}

class _ChatsEventEmitChatsList implements ChatsEvent {
  const _ChatsEventEmitChatsList({required this.data});

  final ChatsCollection data;
}

class _ChatsEventEmitError implements ChatsEvent {
  const _ChatsEventEmitError({required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;
}
