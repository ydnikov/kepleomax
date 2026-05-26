import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/flavor.dart';
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
    channelData: dto.channelData == null
        ? null
        : ChannelData.fromDto(dto.channelData!),
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
}

@freezed
abstract class ChannelData with _$ChannelData {
  const factory ChannelData({
    required int id, // equals to chat_id
    required String name,
    required String description,
    required String tag,
    required String? imageUrl,
    required bool isOfficial,
    required UserChannelRole userRole,
    int? subscribersCount,
  }) = _ChannelData;

  factory ChannelData.fromDto(ChatChannelDataDto dto) => ChannelData(
    id: dto.id,
    name: dto.channelName,
    description: dto.description,
    tag: dto.tag,
    imageUrl: dto.imageUrl,
    isOfficial: dto.isOfficial,
    userRole: UserChannelRole.fromDto(dto.userChannelRole),
  );

  const ChannelData._();

  String get fullTag => '${flavor.baseUrl}/$tag';
}

enum UserChannelRole {
  owner,
  subscriber,
  none;

  factory UserChannelRole.fromDto(UserChannelRoleDto dto) {
    switch (dto) {
      case UserChannelRoleDto.owner:
        return owner;
      case UserChannelRoleDto.subscriber:
        return subscriber;
      case UserChannelRoleDto.none:
        return none;
    }
  }

  bool get isOwner => this == owner;

  bool get isSubscriber => this == subscriber;

  bool get isNone => this == none;
}
