import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/chat.dart';

part 'channel_on_chat_screen_update.freezed.dart';

/// TODO rename?
@freezed
abstract class ChannelOnChatScreenUpdate with _$ChannelOnChatScreenUpdate {
  @Assert(
    'newChannelData == null || (newUserRole == null && newSubsCount == null)',
    'If there is newChannelData, other fields must be null',
  )
  const factory ChannelOnChatScreenUpdate({
    required int channelId,
    ChannelData? newChannelData,
    UserChannelRole? newUserRole,
    int? newSubsCount,
  }) = _ChannelOnChatScreenUpdate;
}
