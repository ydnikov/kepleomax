import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/user.dart';

part 'chat_state.freezed.dart';

abstract class ChatState {}

@freezed
abstract class ChatStateBase with _$ChatStateBase implements ChatState {
  const factory ChatStateBase({required ChatData data}) = _ChatStateBase;

  factory ChatStateBase.initial() => ChatStateBase(data: ChatData.initial());
}

@freezed
abstract class ChatStateError with _$ChatStateError implements ChatState {
  const factory ChatStateError({required String message}) = _ChatStateError;
}

@freezed
abstract class ChatStateMessage with _$ChatStateMessage implements ChatState {
  const factory ChatStateMessage({required String message, required bool isError}) =
      _ChatStateMessage;
}

@freezed
abstract class ChatStateUpdateTextField
    with _$ChatStateUpdateTextField
    implements ChatState {
  const factory ChatStateUpdateTextField(String message) =
      _ChatStateUpdateTextField;
}

@freezed
abstract class ChatData with _$ChatData implements ChatState {
  const factory ChatData({
    required int chatId,
    required User otherUser, // if user in chat was null, this user will be used
    required List<Message> messages,
    required int unreadCount,
    required bool isAllMessagesLoaded,
    required UnreadMessagesValue unreadMessagesValue,
    @Default(false) bool isTyping,
    @Default(true) bool isLoading,
    @Default(false) bool isConnected,
  }) = _ChatData;

  factory ChatData.initial() => ChatData(
    chatId: -1,
    otherUser: User.loading(),
    unreadCount: 0,
    messages: [],
    isAllMessagesLoaded: false,
    unreadMessagesValue: UnreadMessagesValue.initial(),
  );
}

@freezed
abstract class UnreadMessagesValue with _$UnreadMessagesValue {
  const factory UnreadMessagesValue({
    /// if data from cache - set isLocked to false
    /// if data from api - set isLocked to true, in that firstReadMessageCreatedAt
    /// won't change for that ChatState (is handled by chat_bloc)
    required bool isLocked,
    required DateTime? firstReadMessageCreatedAt,
  }) = _UnreadMessagesValue;

  factory UnreadMessagesValue.initial() =>
      const UnreadMessagesValue(isLocked: false, firstReadMessageCreatedAt: null);
}
