import 'package:kepleomax/core/network/apis/chats/chats_api.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';

abstract class ChatsApiDataSource {
  Future<Iterable<ChatDto>> getChats();

  Future<ChatDto> getChatWithId(String chatId);

  // TODO get rid of nullability
  Future<ChatDto?> getChatWithUser(int otherUserId);
}

class ChatsApiDataSourceImpl implements ChatsApiDataSource {
  ChatsApiDataSourceImpl({required ChatsApi chatsApi}) : _chatsApi = chatsApi;

  final ChatsApi _chatsApi;

  @override
  Future<Iterable<ChatDto>> getChats() async {
    final res = await _chatsApi.getChats();
    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ??
            'Failed to get chats, statusCode: ${res.response.statusCode}',
      );
    }
    return res.data.data!;
  }

  @override
  Future<ChatDto> getChatWithId(String chatId) async {
    final res = await _chatsApi.getChatWithId(chatId: chatId);

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get chat: ${res.response.statusCode}',
      );
    }

    return res.data.data!;
  }

  @override
  Future<ChatDto?> getChatWithUser(int otherUserId) async {
    final res = await _chatsApi.getChatWithUser(otherUserId: otherUserId);

    if (res.response.statusCode == 404) {
      return null;
    }
    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get chat: ${res.response.statusCode}',
      );
    }

    return res.data.data!;
  }
}
