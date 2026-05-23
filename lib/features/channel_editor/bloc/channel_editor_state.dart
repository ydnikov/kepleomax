import 'package:freezed_annotation/freezed_annotation.dart';

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
  const factory ChannelEditorStateExit({String? message}) =
      _ChannelEditorStateExit;
}

@freezed
abstract class ChannelEditorData
    with _$ChannelEditorData
    implements ChannelEditorState {
  const factory ChannelEditorData({@Default(false) bool isLoading}) =
      _ChannelEditorData;

  factory ChannelEditorData.initial() => const ChannelEditorData();
}
