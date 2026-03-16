import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/models/post.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/features/post/bloc/post_list_state.dart';
import 'package:kepleomax/features/post/data/post_repository.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  PostListBloc({required PostRepository postRepository, required int? userId})
    : _postRepository = postRepository,
      _userId = userId,
      super(PostListStateBase.initial()) {
    on<PostListEvent>(
      (event, emit) => switch (event) {
        final PostListEventLoad event => _onLoad(event, emit),
        final PostListEventLoadMore event => _onLoadMorePosts(event, emit),
        final PostListEventDeletePost event => _onDeletePost(event, emit),
        _ => () {},
      },
      transformer: sequential(),
    );
  }

  final PostRepository _postRepository;

  late PostListData _data = PostListData.initial();
  final int? _userId;

  int _lastTimeLoadCalled = 0;

  Future<void> _onLoad(PostListEventLoad event, Emitter<PostListState> emit) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_lastTimeLoadCalled + 1000 > now) {
      return;
    }
    _lastTimeLoadCalled = now;

    /// to prevent paging
    _data = _data.copyWith(isNewPostsLoading: true);
    emit(const PostListStateLoading());

    try {
      final posts = await _getPosts();

      _data = _data.copyWith(
        posts: posts,
        isAllPostsLoaded: posts.length < AppConstants.postsPagingLimit,
        isNewPostsLoading: false,
      );
      emit(PostListStateBase(data: _data));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      emit(PostListStateError(message: e.userErrorMessage));
    }
  }

  Future<void> _onLoadMorePosts(
    PostListEventLoadMore event,
    Emitter<PostListState> emit,
  ) async {
    if (_data.isNewPostsLoading || _data.isAllPostsLoaded) return;

    _data = _data.copyWith(isNewPostsLoading: true);
    emit(PostListStateBase(data: _data));

    final oldPosts = _data.posts;
    try {
      final newPosts = await _getPosts(cursor: _data.posts.lastOrNull?.id);

      _data = _data.copyWith(
        isAllPostsLoaded: newPosts.length < AppConstants.postsPagingLimit,
        posts: [...oldPosts, ...newPosts],
      );
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      _data = _data.copyWith(isAllPostsLoaded: true);
      emit(PostListStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      _data = _data.copyWith(isNewPostsLoading: false);
      emit(PostListStateBase(data: _data));
    }
  }

  Future<void> _onDeletePost(
    PostListEventDeletePost event,
    Emitter<PostListState> emit,
  ) async {
    final oldPosts = [..._data.posts];
    final newPosts = _data.posts.toList();
    _data = _data.copyWith(
      posts: newPosts
        ..[event.index] = newPosts[event.index].copyWith(isMockLoadingPost: true),
    );
    emit(PostListStateBase(data: _data));

    try {
      await _postRepository.deletePost(postId: event.postId);
      _data = _data = _data.copyWith(posts: newPosts..removeAt(event.index));
      emit(const PostListStateMessage(message: 'Post deleted'));
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      _data = _data.copyWith(posts: oldPosts);
      emit(PostListStateMessage(message: e.userErrorMessage, isError: true));
    } finally {
      emit(PostListStateBase(data: _data));
    }
  }

  Future<List<Post>> _getPosts({int? cursor}) async {
    if (_userId == null) {
      return _postRepository.getPosts(
        limit: AppConstants.postsPagingLimit,
        cursor: cursor,
      );
    } else {
      return _postRepository.getPostsByUserId(
        userId: _userId,
        limit: AppConstants.postsPagingLimit,
        cursor: cursor,
      );
    }
  }
}

/// events
abstract class PostListEvent {}

class PostListEventLoad implements PostListEvent {
  const PostListEventLoad();
}

class PostListEventLoadMore implements PostListEvent {
  const PostListEventLoadMore();
}

class PostListEventDeletePost implements PostListEvent {
  PostListEventDeletePost({required this.index, required this.postId});

  final int index;
  final int postId;
}
