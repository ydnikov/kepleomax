import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/chat.dart';
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

    _usersSub = _channelRepository.usersStream.listen((list) {
      _data = _data.copyWith(subs: list);
      add(const _ChannelEventEmit());
    });

    on<ChannelEventLoad>(_onLoad);
    on<ChannelEventEdited>(_onEdited);
    on<ChannelEventSubscribe>(_onSubscribe);
    on<ChannelEventUnsubscribe>(_onUnsubscribe);
    on<_ChannelEventEmit>(_onEmit);
  }

  late final StreamSubscription<void> _usersSub;
  final ChannelRepository _channelRepository;
  late ChannelScreenData _data;

  Future<void> _onLoad(ChannelEventLoad event, Emitter<ChannelState> emit) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      /// TODO start loading subsCount and subs at the same time
      if (_data.channelData.subscribersCount == null) {
        final subsCount = await _channelRepository.getSubscribersCount(
          channelId: _data.channelData.id,
        );
        _data = _data.copyWith(
          channelData: _data.channelData.copyWith(subscribersCount: subsCount),
        );
        emit(ChannelStateBase(_data));
      }

      if (_data.channelData.userRole.isOwner) {
        await _channelRepository.loadSubscribers(channelId: _data.channelData.id);
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
    if (_data.channelData.subscribersCount == null) return;

    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      final fakeDelay = AppConstants.fakeDelay;

      await _channelRepository.subscribe(channelId: _data.channelData.id);
      _data = _data.copyWith(
        channelData: _data.channelData.copyWith(
          userRole: UserChannelRole.subscriber,
          subscribersCount: _data.channelData.subscribersCount! + 1,
        ),
      );

      await fakeDelay;
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
    if (_data.channelData.subscribersCount == null) return;

    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      final fakeDelay = AppConstants.fakeDelay;
      await _channelRepository.unsubscribe(
        channelId: _data.channelData.id,
        userId: event.userId,
      );
      await fakeDelay;

      if (event.userId == null) {
        _data = _data.copyWith(
          channelData: _data.channelData.copyWith(
            userRole: UserChannelRole.none,
            subscribersCount: _data.channelData.subscribersCount! - 1,
          ),
        );
      } else {
        _data = _data.copyWith(
          subs: _data.subs.where((user) => user.id != event.userId).toList(),
          channelData: _data.channelData.copyWith(
            subscribersCount: _data.channelData.subscribersCount! - 1,
          ),
        );
      }
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelStateBase(_data));
    }
  }

  void _onEdited(ChannelEventEdited event, Emitter<ChannelState> emit) {
    _data = _data.copyWith(
      channelData: event.newChannelData.copyWith(
        subscribersCount: _data.channelData.subscribersCount,
      ),
    );
    emit(ChannelStateBase(_data));
  }

  void _onEmit(_ChannelEventEmit event, Emitter<ChannelState> emit) {
    emit(ChannelStateBase(_data));
  }

  @override
  Future<void> close() async {
    await _usersSub.cancel();
    return super.close();
  }
}

/// events
abstract class ChannelEvent {}

class ChannelEventLoad implements ChannelEvent {
  const ChannelEventLoad({this.full = false});

  final bool full;
}

class ChannelEventEdited implements ChannelEvent {
  const ChannelEventEdited(this.newChannelData);

  final ChannelData newChannelData;
}

class ChannelEventSubscribe implements ChannelEvent {
  const ChannelEventSubscribe();
}

class ChannelEventUnsubscribe implements ChannelEvent {
  const ChannelEventUnsubscribe({this.userId});

  final int? userId;
}

class _ChannelEventEmit implements ChannelEvent {
  const _ChannelEventEmit();
}
