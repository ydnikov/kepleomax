import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/core/presentation/validators.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';

UiValidator channelNameValidator = UiValidators.createLengthValidator(3);
UiValidator channelTagValidator = UiValidators.channelTagValidator;

class ChannelEditorBloc extends Bloc<ChannelEditorEvent, ChannelEditorState> {
  ChannelEditorBloc({
    required ChannelEditorRepository repository,
    required int? channelId,
  }) : _channelId = channelId,
       _editorRepository = repository,
       super(ChannelEditorStateBase.initial()) {
    on<ChannelEditorEventCreate>(_onCreate);
    on<ChannelEditorEventSaveChanges>(_onSaveChanges);
  }

  final ChannelEditorRepository _editorRepository;
  final int? _channelId;
  ChannelEditorData _data = ChannelEditorData.initial();

  Future<void> _onCreate(
    ChannelEditorEventCreate event,
    Emitter<ChannelEditorState> emit,
  ) async {
    _data = _data.copyWith(isLoading: true);
    emit(ChannelEditorStateBase(_data));

    try {
      final chat = await _editorRepository.createNewChannel(
        channelUiData: event.channelEditingData,
      );

      emit(
        ChannelEditorStateExit(
          message: 'Channel successfully created',
          navigateToChatScreen: chat,
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
      await _editorRepository.editChannel(
        channelId: _channelId!,
        channelUiData: event.channelEditingData,
      );

      emit(const ChannelEditorStateExit(message: 'Changes are saved'));
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
