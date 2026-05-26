import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/core/presentation/validators.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';
import 'package:kepleomax/features/channel_editor/data/channel_editor_repository.dart';

UiValidator channelNameValidator = UiValidators.createLengthValidator(3);
UiValidator channelTagValidator = UiValidators.channelTagValidator;

class ChannelEditorBloc extends Bloc<ChannelEditorEvent, ChannelEditorState> {
  ChannelEditorBloc({
    required ChannelEditorRepository repository,
    required this.channelId,
  }) : _repository = repository,
       super(ChannelEditorStateBase.initial()) {
    on<ChannelEditorEventCreate>(_onCreate);
    on<ChannelEditorEventSaveChanges>(_onSaveChanges);
  }

  final ChannelEditorRepository _repository;
  final int? channelId;
  ChannelEditorData _data = ChannelEditorData.initial();

  Future<void> _onCreate(
    ChannelEditorEventCreate event,
    Emitter<ChannelEditorState> emit,
  ) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelEditorStateBase(_data));

    try {
      final channelData = await _repository.createNewChannel(
        channelData: event.channelEditingData,
      );

      emit(
        ChannelEditorStateExit(
          message: 'Channel successfully created',
          newChannelData: channelData,
        ),
      );
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelEditorStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelEditorStateBase(_data));
    }
  }

  Future<void> _onSaveChanges(
    ChannelEditorEventSaveChanges event,
    Emitter<ChannelEditorState> emit,
  ) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelEditorStateBase(_data));

    try {
      final channelData = await _repository.editChannel(
        channelId: channelId!,
        channelData: event.channelEditingData,
      );

      emit(
        ChannelEditorStateExit(
          message: 'Changes are saved',
          newChannelData: channelData,
        ),
      );
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(ChannelEditorStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isLoading: false);
      emit(ChannelEditorStateBase(_data));
    }
  }
}

/// events
abstract class ChannelEditorEvent {}

class ChannelEditorEventCreate implements ChannelEditorEvent {
  const ChannelEditorEventCreate({required this.channelEditingData});

  final ChannelEditingUiData channelEditingData;
}

class ChannelEditorEventSaveChanges implements ChannelEditorEvent {
  const ChannelEditorEventSaveChanges({required this.channelEditingData});

  final ChannelEditingUiData channelEditingData;
}
