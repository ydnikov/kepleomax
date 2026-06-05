import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/extensions/fake_delay_extension.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/features/channel/bloc/channel_state.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  ChannelBloc({
    required ChannelData channelData,
    required ChannelRepository channelRepository,
  }) : _channelRepository = channelRepository,
       super(ChannelStateBase.initial(channelData: channelData)) {
    _data = ChannelScreenData.initial(channelData: channelData);

    _subs.addAll([
      _channelRepository.usersStream.listen((list) {
        add(_ChannelEventOnSubsUpdate(users: list));
      }),
      _channelRepository.channelUpdatesStream.listen((channelData) {
        if (channelData.id != _data.channelData.id) return;
        add(_ChannelEventOnUpdate(channelData: channelData));
      }),
      _channelRepository.channelDeletedStream.listen((channelId) {
        if (channelId != _data.channelData.id) return;
        add(const ChannelEventDeleted());
      }),
    ]);

    on<ChannelEvent>(
      (event, emit) => switch (event) {
        final ChannelEventLoad event => _onLoad(event, emit),
        final ChannelEventSubscribe event => _onSubscribe(event, emit),
        final ChannelEventUnsubscribe event => _onUnsubscribe(event, emit),
        final ChannelEventDelete event => _onDelete(event, emit),
        final _ChannelEventOnUpdate event => _onUpdate(event, emit),
        final _ChannelEventOnSubsUpdate event => _onSubsUpdate(event, emit),
        _ => null,
      },
      transformer: sequential(),
    );
    on<ChannelEventDeleted>(_onDeleted);
  }

  final List<StreamSubscription<void>> _subs = [];
  final ChannelRepository _channelRepository;
  late ChannelScreenData _data;

  Future<void> _onLoad(ChannelEventLoad event, Emitter<ChannelState> emit) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      await _channelRepository.init(channelData: _data.channelData);

      if (_data.channelData.userRole.isOwner) {
        await _channelRepository.loadSubscribers();
      }
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelStateBase(_data));
    }
  }

  Future<void> _onSubscribe(
    ChannelEventSubscribe event,
    Emitter<ChannelState> emit,
  ) async {
    if (_data.isLoading) return;

    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      await _channelRepository.subscribe().withFakeDelay();
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelStateBase(_data));
    }
  }

  Future<void> _onUnsubscribe(
    ChannelEventUnsubscribe event,
    Emitter<ChannelState> emit,
  ) async {
    if (_data.isLoading) return;

    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      await _channelRepository.unsubscribe(userId: event.userId).withFakeDelay();
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelStateBase(_data));
    }
  }

  Future<void> _onDelete(
    ChannelEventDelete event,
    Emitter<ChannelState> emit,
  ) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      await _channelRepository
          .deleteChannel(channelId: _data.channelData.id)
          .withFakeDelay();


      /// don't add ChannelEventDeleted, cause it will be added via ws
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelStateBase(_data));
    }
  }

  void _onDeleted(ChannelEventDeleted event, Emitter<ChannelState> emit) {
    emit(const ChannelStateDeleted());
  }

  void _onUpdate(_ChannelEventOnUpdate event, Emitter<ChannelState> emit) {
    _data = _data.copyWith(channelData: event.channelData);
    emit(ChannelStateBase(_data));
  }

  void _onSubsUpdate(_ChannelEventOnSubsUpdate event, Emitter<ChannelState> emit) {
    _data = _data.copyWith(subs: event.users);
    emit(ChannelStateBase(_data));
  }

  @override
  Future<void> close() async {
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    return super.close();
  }
}

/// events
abstract class ChannelEvent {}

class ChannelEventLoad implements ChannelEvent {
  const ChannelEventLoad({this.full = false});

  final bool full;
}

class ChannelEventSubscribe implements ChannelEvent {
  const ChannelEventSubscribe();
}

class ChannelEventUnsubscribe implements ChannelEvent {
  const ChannelEventUnsubscribe({this.userId});

  final int? userId;
}

class ChannelEventDelete implements ChannelEvent {
  const ChannelEventDelete();
}

class ChannelEventDeleted implements ChannelEvent {
  const ChannelEventDeleted();
}

class _ChannelEventOnUpdate implements ChannelEvent {
  const _ChannelEventOnUpdate({required this.channelData});

  final ChannelData channelData;
}

class _ChannelEventOnSubsUpdate implements ChannelEvent {
  const _ChannelEventOnSubsUpdate({required this.users});

  final List<User> users;
}
