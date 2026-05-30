import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/chat.dart';

part 'channel_editor_state.freezed.dart';

abstract class ChannelEditorState {}

@freezed
abstract class ChannelEditorStateBase
    with _$ChannelEditorStateBase
    implements ChannelEditorState {
  const factory ChannelEditorStateBase(ChannelEditorData data) =
      _ChannelEditorStateBase;

  factory ChannelEditorStateBase.initial() =>
      ChannelEditorStateBase(ChannelEditorData.initial());
}

@freezed
abstract class ChannelEditorStateMessage
    with _$ChannelEditorStateMessage
    implements ChannelEditorState {
  const factory ChannelEditorStateMessage({
    required String message,
    @Default(false) bool isError,
  }) = _ChannelEditorStateMessage;
}

@freezed
abstract class ChannelEditorStateExit
    with _$ChannelEditorStateExit
    implements ChannelEditorState {
  const factory ChannelEditorStateExit({
    required ChannelData newChannelData,
    String? message,
  }) = _ChannelEditorStateExit;
}

@freezed
abstract class ChannelEditorData
    with _$ChannelEditorData
    implements ChannelEditorState {
  const factory ChannelEditorData({@Default(false) bool isLoading}) =
      _ChannelEditorData;

  factory ChannelEditorData.initial() => const ChannelEditorData();
}

@freezed
abstract class ChannelEditingUiData with _$ChannelEditingUiData {
  const factory ChannelEditingUiData({
    required String name,
    required String description,
    required String tag,
    required String? imagePath,
  }) = _ChannelEditingUiData;

  factory ChannelEditingUiData.fromChannelData(ChannelData? data) => data == null
      ? ChannelEditingUiData.initial()
      : ChannelEditingUiData(
          name: data.name,
          description: data.description,
          tag: data.tag,
          imagePath: null,
        );

  factory ChannelEditingUiData.initial() =>
      const ChannelEditingUiData(name: '', description: '', tag: '', imagePath: null);
}
