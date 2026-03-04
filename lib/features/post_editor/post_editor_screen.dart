import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/post.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/image_url_or_file.dart';
import 'package:kepleomax/core/presentation/klm_cached_image.dart';
import 'package:kepleomax/features/post_editor/bloc/post_editor_bloc.dart';
import 'package:kepleomax/features/post_editor/bloc/post_editor_state.dart';

part 'widgets/post_editor_images.dart';

/// screen
class PostEditorScreen extends StatelessWidget {
  const PostEditorScreen({
    required Post? post,
    required void Function() onPostSaved,
    super.key,
  }) : _post = post,
       _onSave = onPostSaved;

  final Post? _post;
  final VoidCallback _onSave;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostEditorBloc>(
      create: (context) => PostEditorBloc(
        filesRepository: Dependencies.of(context).filesRepository,
        postRepository: Dependencies.of(context).postRepository,
      )..add(PostEditorEventInit(post: _post)),
      child: BlocListener<PostEditorBloc, PostEditorState>(
        listener: (context, state) {
          if (state is PostEditorStateError) {
            context.showSnackBar(text: state.message, color: KlmColors.errorRed);
          }

          if (state is PostEditorStateExit) {
            if (state.refreshPostsList) {
              _onSave();
            }

            AppNavigator.withKeyOf(context, mainNavigatorKey)!.pop();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _AppBar(isEditing: _post != null, key: const Key('post_editor_app_bar')),
          body: const _Body(key: Key('post_editor_body')),
        ),
      ),
    );
  }
}

/// body
class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _controller = TextEditingController();

  /// callbacks
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// listeners
  void _updateControllers(PostEditorData data) {
    _controller.text = data.text;
    setState(() {});
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostEditorBloc, PostEditorState>(
      buildWhen: (oldState, newState) {
        if (newState is! PostEditorStateBase) return false;

        if (oldState is! PostEditorStateBase) return true;

        return !listEquals(oldState.data.images, newState.data.images) ||
            oldState.data.isLoading != newState.data.isLoading;
      },
      listener: (context, state) {
        if (state is PostEditorStateBase && state.updateControllers) {
          _updateControllers(state.data);
        }
      },
      builder: (context, state) {
        if (state is! PostEditorStateBase) return const SizedBox();

        final data = state.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _Images(images: data.images, isLoading: data.isLoading),
                      TextFormField(
                        controller: _controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: data.isLoading ? '' : 'Write something here...',
                        ),
                        maxLength: 4000,
                        readOnly: data.isLoading,
                        onChanged: (newText) {
                          context.read<PostEditorBloc>().add(
                            PostEditorEventEditText(newText: newText),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: data.isLoading || data.images.length >= imagesCountLimit
                    ? null
                    : () {
                        context.read<PostEditorBloc>().add(
                          const PostEditorEventAddPhotos(),
                        );
                      },
                child: Text(
                  'Add photos',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: data.isLoading || data.images.length >= imagesCountLimit
                        ? KlmColors.inactiveColor
                        : KlmColors.primaryColor.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.isEditing, super.key});

  /// isEditing - or creating a new one
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostEditorBloc, PostEditorState>(
      buildWhen: (oldState, newState) {
        if (newState is! PostEditorStateBase) return false;

        if (oldState is! PostEditorStateBase) return true;

        return oldState.data != newState.data;
      },
      builder: (context, state) {
        if (state is! PostEditorStateBase) return const SizedBox();

        final data = state.data;
        return AppBar(
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          forceMaterialTransparency: true,
          title: Text(
            isEditing ? 'Edit post' : 'New Post',
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: KlmColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            onPressed: () {
              AppNavigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: data.isLoading || data.isEmpty()
                  ? null
                  : () {
                      context.read<PostEditorBloc>().add(
                        const PostEditorEventSave(),
                      );
                    },
              child: data.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: KlmColors.inactiveColor,
                      ),
                    )
                  : Text(
                      isEditing ? 'Save' : 'Post',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: data.isLoading || data.isEmpty()
                            ? KlmColors.inactiveColor
                            : KlmColors.primaryColor,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
