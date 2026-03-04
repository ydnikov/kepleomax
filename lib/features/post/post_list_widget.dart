import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/models/post.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_error_widget.dart';
import 'package:kepleomax/features/post/bloc/post_list_bloc.dart';
import 'package:kepleomax/features/post/bloc/post_list_state.dart';
import 'package:kepleomax/features/post/post_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// must be BlocProvider above with PostListBloc
class PostListWidget extends StatelessWidget {
  const PostListWidget({required this.isUserPage, super.key});

  final bool isUserPage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostListBloc, PostListState>(
      /// don't need buildWhen
      listener: (context, state) {
        if (state is PostListStateMessage) {
          context.showSnackBar(
            text: state.message,
            color: state.isError ? KlmColors.errorRed : KlmColors.success,
          );
        }
      },
      builder: (context, state) {
        if (state is PostListStateLoading) {
          /// loading
          return Skeletonizer(
            child: Column(
              children: [
                PostWidget(post: Post.loading()),
                PostWidget(post: Post.loading()),
                PostWidget(post: Post.loading()),
                const SizedBox(height: 16),
              ],
            ),
          );
        } else if (state is PostListStateError) {
          /// error
          return KlmErrorWidget(
            errorMessage: state.message,
            onRetry: () {
              context.read<PostListBloc>().add(const PostListEventLoad());
            },
          );
        } else if (state is PostListStateBase) {
          /// base
          final data = state.data;
          return Column(
            children: [
              ...data.posts.mapIndexed(
                (i, post) => PostWidget(
                  key: Key('post_widget_${post.id}'),
                  post: post,
                  onDelete: !isUserPage
                      ? null
                      : () {
                          context.read<PostListBloc>().add(
                            PostListEventDeletePost(index: i, postId: post.id),
                          );
                        },
                  onEdit: !isUserPage
                      ? null
                      : () {
                          AppNavigator.withKeyOf(context, mainNavigatorKey)!.push(
                            PostEditorPage(
                              post: post,
                              onPostSaved: () {
                                context.read<PostListBloc>().add(
                                  const PostListEventLoad(),
                                );
                              },
                            ),
                          );
                        },
                  onUserTap: isUserPage
                      ? null
                      : () {
                          AppNavigator.of(
                            context,
                          )?.push(UserPage(userId: post.user.id));
                        },
                ),
              ),

              if (data.isAllPostsLoaded && isUserPage)
                Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Text(
                      data.posts.isEmpty
                          ? 'No posts'
                          : '${data.posts.length} ${data.posts.length == 1 ? 'post' : 'posts'}',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              else if (!data.isAllPostsLoaded)
                PostWidget(post: Post.loading()),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
