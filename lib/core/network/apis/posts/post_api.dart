import 'package:dio/dio.dart';
import 'package:kepleomax/core/network/apis/posts/post_dtos.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApi {
  factory PostApi(Dio dio, String baseUrl) =>
      _PostApi(dio, baseUrl: '$baseUrl/api/posts');

  @POST('/')
  Future<HttpResponse<PostResponseDto>> createNewPost({
    @Body() required CreatePostRequestDto data,
  });

  @GET('/byUserId')
  Future<HttpResponse<PostsResponseDto>> getPostsByUserId({
    @Query('userId') required int userId,
    @Query('limit') required int limit,
    @Query('cursor') int? cursor,
  });

  @GET('/')
  Future<HttpResponse<PostsResponseDto>> getPosts({
    @Query('limit') required int limit,
    @Query('cursor') int? cursor,
  });

  @DELETE('/')
  Future<HttpResponse<PostResponseDto>> deletePost({
    @Query('postId') required int postId,
  });

  @PUT('/')
  Future<HttpResponse<PostResponseDto>> updatePost({
    @Query('postId') required int postId,
    @Body() required CreatePostRequestDto data,
  });
}
