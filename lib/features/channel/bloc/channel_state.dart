import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';

part 'channel_state.freezed.dart';

abstract class ChannelState {}

@freezed
abstract class ChannelStateBase with _$ChannelStateBase implements ChannelState {
  const factory ChannelStateBase(ChannelScreenData data) = _ChannelStateBase;

  factory ChannelStateBase.initial({required ChannelData channelData}) =>
      ChannelStateBase(ChannelScreenData.initial(channelData: channelData));
}

@freezed
abstract class ChannelStateMessage
    with _$ChannelStateMessage
    implements ChannelState {
  const factory ChannelStateMessage({
    required String message,
    @Default(false) bool isError,
  }) = _ChannelStateMessage;
}

@freezed
abstract class ChannelStateDeleted
    with _$ChannelStateDeleted
    implements ChannelState {
  const factory ChannelStateDeleted({@Default(true) bool showToast}) =
      _ChannelStateDeleted;
}

@freezed
abstract class ChannelScreenData with _$ChannelScreenData implements ChannelState {
  const factory ChannelScreenData({
    required ChannelData channelData,
    required List<User> subs,
    @Default(true) bool isLoading,
    @Default(false) bool isConnected,
  }) = _ChannelData;

  factory ChannelScreenData.initial({required ChannelData channelData}) =>
      ChannelScreenData(channelData: channelData, subs: []);
}
