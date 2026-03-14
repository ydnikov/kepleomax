import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/models/chat.dart';

part 'chats_collection.freezed.dart';

@freezed
abstract class ChatsCollection with _$ChatsCollection {
  /// now there is no chats paging, so fromCache: true means EACH chat from cache
  /// and fromCache: false means EACH chat from api
  const factory ChatsCollection({
    required List<Chat> chats,
    @Default(false) bool fromCache,
  }) = _ChatsCollection;
}
