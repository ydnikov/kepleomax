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
  );

  factory Chat.loading() => Chat(
    id: _loadingChatId,
    otherUser: User.loading(),
    fromCache: false,
    lastMessage: Message.loading(),
    unreadCount: 0,
  );

  static const int _loadingChatId = -2;

  bool get isTypingRightNow =>
      lastTypingActivityTime != null &&
      lastTypingActivityTime!.millisecondsSinceEpoch +
              AppConstants.showTypingAfterActivity.inMilliseconds >
          DateTime.now().millisecondsSinceEpoch;

  bool get isLoadingChat => id == _loadingChatId;

  ChatDto toDto() => ChatDto(
    id: id,
    otherUser: otherUser.toDto(),
    lastMessage: lastMessage?.toDto(),
    draft: draft,
    unreadCount: unreadCount,
  );
}
