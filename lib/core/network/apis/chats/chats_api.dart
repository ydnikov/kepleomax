import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'chats_api.g.dart';

@RestApi()
abstract class ChatsApi {
  factory ChatsApi(Dio dio, String baseUrl) =>
      _ChatsApi(dio, baseUrl: '$baseUrl/api/chats');

  @GET('/')
  Future<HttpResponse<ChatsResponse>> getChats();

  @GET('/{id}')
  Future<HttpResponse<ChatResponse>> getChatWithId({
    @Path('id') required String chatId,
  });

  @GET('/withUser')
  Future<HttpResponse<ChatResponse>> getChatWithUser({
    @Query('userId') required int otherUserId,
  });
}
