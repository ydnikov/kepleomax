import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/apis/messages/messages_api.dart';

abstract class MessagesApiDataSource {
  Future<List<MessageDto>> getMessages({
    required int chatId,
    required int limit,
    int? cursor,
  });
}

class MessagesApiDataSourceImpl implements MessagesApiDataSource {
  MessagesApiDataSourceImpl({required MessagesApi messagesApi})
    : _messagesApi = messagesApi;

  final MessagesApi _messagesApi;

  @override
  Future<List<MessageDto>> getMessages({
    required int chatId,
    required int limit,
    int? cursor,
  }) async {
    final res = await _messagesApi.getMessages(
      chatId: chatId,
      limit: limit,
      cursor: cursor,
    );
    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get messages: ${res.response.statusCode}',
      );
    }
    return res.data.data!;
  }
}
