import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/chat.dart';

part 'channel_update.freezed.dart';

@freezed
abstract class ChannelUpdate with _$ChannelUpdate {
  const factory ChannelUpdate({
    required int channelId,
    required ChannelData newChannelData,
  }) = _ChannelUpdate;
}
