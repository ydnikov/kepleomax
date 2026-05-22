import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/message_draft.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';

part 'chat.freezed.dart';

@freezed
abstract class Chat with _$Chat {
  const factory Chat({
    required int id,
    required User otherUser,
    required ChannelData? channelData,
    required Message? lastMessage,
    required bool fromCache,
    required int unreadCount,
    MessageDraft? draft,
    DateTime? lastTypingActivityTime,
  }) = _Chat;

  const Chat._();

  factory Chat.fromDto(ChatDto dto, {required bool fromCache}) => Chat(
    id: dto.id,
    otherUser: User.fromDto(dto.otherUser),
    lastMessage: dto.lastMessage == null ? null : Message.fromDto(dto.lastMessage!),
    draft: dto.draft,
    fromCache: fromCache,
    unreadCount: dto.unreadCount,
    channelData: dto.otherUser.id != 2 ? null : const ChannelData(
      name: 'KepLeoMax News',
      isOfficial: true,
      currentUserIsOwner: false,
    ),
  );

  factory Chat.loading() => Chat(
    id: _loadingChatId,
    otherUser: User.loading(),
    fromCache: false,
    lastMessage: Message.loading(),
    unreadCount: 0,
    channelData: null,
  );

  static const int _loadingChatId = -1;

  bool get isTypingRightNow =>
      lastTypingActivityTime != null &&
      lastTypingActivityTime!.millisecondsSinceEpoch +
              AppConstants.showTypingAfterActivity.inMilliseconds >
          DateTime.now().millisecondsSinceEpoch;

  bool get isLoadingChat => id == _loadingChatId;

  bool get isChannel => channelData != null;

  ChatDto toDto() => ChatDto(
    id: id,
    otherUser: otherUser.toDto(),
    lastMessage: lastMessage?.toDto(),
    draft: draft,
    unreadCount: unreadCount,
  );
}

@freezed
abstract class ChannelData with _$ChannelData {
  const factory ChannelData({
    required String name,
    required bool isOfficial,
    required bool currentUserIsOwner,
  }) = _ChannelData;
}
