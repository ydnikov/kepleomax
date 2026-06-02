import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/message.dart';

part 'messages_collection.freezed.dart';

@freezed
abstract class MessagesCollection with _$MessagesCollection {
  const factory MessagesCollection({
    required int chatId,
    required Iterable<Message> messages,

    /// if get messages from cache, loading still have to be visible
    @Default(false) bool fromCache,
    bool? allMessagesLoaded,
  }) = _MessagesCollection;
}
