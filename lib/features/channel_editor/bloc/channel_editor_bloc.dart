import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/presentation/validators.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';
import 'package:kepleomax/features/channel_editor/data/channel_editor_repository.dart';

UiValidator channelNameValidator = UiValidators.createLengthValidator(3);
const UiValidator channelTagValidator = UiValidators.channelTagValidator;

class ChannelEditorBloc extends Bloc<ChannelEditorEvent, ChannelEditorState> {
  ChannelEditorBloc({required ChannelEditorRepository repository})
    : _repository = repository,
      super(ChannelEditorStateBase.initial()) {
    on<ChannelEditorEventLoad>(_onLoad);
    on<ChannelEditorEventCreate>(_onCreate);
  }

  final ChannelEditorRepository _repository;
  ChannelEditorData _data = ChannelEditorData.initial();

  Future<void> _onLoad(
    ChannelEditorEventLoad event,
    Emitter<ChannelEditorState> emit,
  ) async {}

  Future<void> _onCreate(
    ChannelEditorEventCreate event,
    Emitter<ChannelEditorState> emit,
  ) async {
    if (channelNameValidator(event.name) != null) return;

    _data = _data.copyWith(isLoading: true);
    emit(ChannelEditorStateBase(_data));

    try {
      await _repository.createNewChannel(
        name: event.name,
        description: event.description,
        tag: event.tag,
      );

      emit(const ChannelEditorStateExit(message: 'Channel successfully created'));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(
        const ChannelEditorStateMessage(
          message: 'Failed to create new channel',
          isError: true,
        ),
      );
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelEditorStateBase(_data));
    }
  }
}

/// events
abstract class ChannelEditorEvent {}

class ChannelEditorEventLoad implements ChannelEditorEvent {
  const ChannelEditorEventLoad();
}

class ChannelEditorEventCreate implements ChannelEditorEvent {
  const ChannelEditorEventCreate({
    required this.name,
    required this.description,
    required this.tag,
  });

  final String name;
  final String description;
  final String tag;
}
