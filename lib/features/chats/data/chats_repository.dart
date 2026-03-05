import 'dart:async';

import 'package:kepleomax/core/data/data_sources/chats_api_data_sources.dart';
import 'package:kepleomax/core/data/local_data_sources/chats_local_data_source.dart';
import 'package:kepleomax/core/models/chat.dart';


abstract class ChatsRepository {
  /// api
  Future<Chat?> getChatWithUser(int otherUserId);

  Future<Chat?> getChatWithId(int chatId);

  /// cache
  Future<Chat?> getChatWithUserFromCache(int otherUserId);

  Future<Chat?> getChatWithIdFromCache(int chatId);
}

class ChatsRepositoryImpl implements ChatsRepository {

  ChatsRepositoryImpl({
    required ChatsApiDataSource chatsApi,
    required ChatsLocalDataSource chatsLocalDataSource,
  }) : _chatsLocal = chatsLocalDataSource,
       _chatsApi = chatsApi;
  final ChatsApiDataSource _chatsApi;
  final ChatsLocalDataSource _chatsLocal;

  /// api
  @override
  Future<Chat?> getChatWithUser(int otherUserId) async {
    final dto = await _chatsApi
        .getChatWithUser(otherUserId);

    return dto == null ? null : Chat.fromDto(dto, fromCache: false);
  }

  @override
  Future<Chat?> getChatWithId(int chatId) async {
    final dto = await _chatsApi
        .getChatWithId(chatId);

    if (dto == null) return null;

    _chatsLocal.insert(dto);
    return Chat.fromDto(dto, fromCache: false);
  }

  /// cache
  @override
  Future<Chat?> getChatWithUserFromCache(int otherUserId) async {
    final chatDto = await _chatsLocal.getChatByOtherUserId(otherUserId);

    if (chatDto == null) {
      return null;
    } else {
      return Chat.fromDto(chatDto, fromCache: true);
    }
  }

  @override
  Future<Chat?> getChatWithIdFromCache(int chatId) async {
    final dto = await _chatsLocal.getChat(chatId);
    if (dto == null) return null;
    return Chat.fromDto(dto, fromCache: true);
  }
}
