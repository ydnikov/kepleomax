import 'package:kepleomax/core/models/post.dart';
import 'package:kepleomax/core/network/apis/posts/post_api.dart';
import 'package:kepleomax/core/network/apis/posts/post_dtos.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({
    required int limit,
    required int offset,
    required int cursor,
  });

  Future<List<Post>> getPostsByUserId({
    required int userId,
    required int limit,
    required int offset,
    required int cursor,
  });

  Future<Post> createNewPost({
    required String content,
    required List<String> images,
  });

  Future<Post> updatePost({
    required int postId,
    required String content,
    required List<String> images,
  });

  Future<Post> deletePost({required int postId});
}

/// without PostApiDataSource, just postApi
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required PostApi postApi}) : _postApi = postApi;
  final PostApi _postApi;

  @override
  Future<List<Post>> getPosts({
    required int limit,
    required int offset,
    required int cursor,
  }) async {
    final res = await _postApi.getPosts(
      limit: limit,
      offset: offset,
      cursor: cursor,
    );

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get posts: ${res.response.statusCode}',
      );
    }

    return res.data.data!.map(Post.fromDto).toList();
  }

  @override
  Future<List<Post>> getPostsByUserId({
    required int userId,
    required int limit,
    required int offset,
    required int cursor,
  }) async {
    final res = await _postApi.getPostsByUserId(
      userId: userId,
      limit: limit,
      offset: offset,
      cursor: cursor,
    );

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to get posts: ${res.response.statusCode}',
      );
    }

    return res.data.data!.map(Post.fromDto).toList();
  }

  @override
  Future<Post> createNewPost({
    required String content,
    required List<String> images,
  }) async {
    final res = await _postApi.createNewPost(
      data: CreatePostRequestDto(content: content.trim(), images: images),
    );

    if (res.response.statusCode != 201) {
      throw Exception(
        res.data.message ?? 'Failed to create new post: ${res.response.statusCode}',
      );
    }

    return Post.fromDto(res.data.data!);
  }

  @override
  Future<Post> updatePost({
    required int postId,
    required String content,
    required List<String> images,
  }) async {
    final res = await _postApi.updatePost(
      postId: postId,
      data: CreatePostRequestDto(content: content.trim(), images: images),
    );

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to update the post: ${res.response.statusCode}',
      );
    }

    return Post.fromDto(res.data.data!);
  }

  @override
  Future<Post> deletePost({required int postId}) async {
    final res = await _postApi.deletePost(postId: postId);

    if (res.response.statusCode != 200) {
      throw Exception(
        res.data.message ?? 'Failed to delete the post: ${res.response.statusCode}',
      );
    }

    return Post.fromDto(res.data.data!);
  }
}
