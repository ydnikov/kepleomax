import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/chat.dart';
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
    on<_ChannelEventEmit>(_onEmit);
  }

  late final StreamSubscription<void> _usersSub;
  final ChannelRepository _channelRepository;
  late ChannelScreenData _data;

  Future<void> _onLoad(ChannelEventLoad event, Emitter<ChannelState> emit) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelStateBase(_data));

    try {
      final subsCount = await _channelRepository.getSubscribersCount(
        channelId: _data.channelData.id,
      );
      _data = _data.copyWith(
        channelData: _data.channelData.copyWith(subscribersCount: subsCount),
      );
      emit(ChannelStateBase(_data));

      await _channelRepository.loadSubscribers(channelId: _data.channelData.id);
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(
        const ChannelStateMessage(
          message: 'Failed to get actual data',
          isError: true,
        ),
      );
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelStateBase(_data));
    }
  }

  void _onEmit(_ChannelEventEmit event, Emitter<ChannelState> emit) {
    emit(ChannelStateBase(_data));
  }

  @override
  Future<void> close() async {
    await _usersSub.cancel();
    await _channelRepository.dispose();
    return super.close();
  }
}

/// events
abstract class ChannelEvent {}

class ChannelEventLoad implements ChannelEvent {
  const ChannelEventLoad();
}

class _ChannelEventEmit implements ChannelEvent {
  const _ChannelEventEmit();
}