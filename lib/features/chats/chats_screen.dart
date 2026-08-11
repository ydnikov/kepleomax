import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/channel_image_widget.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/divider_with_padding.dart';
import 'package:kepleomax/core/presentation/ellipsis_text_widget.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';
import 'package:kepleomax/core/presentation/klm_error_widget.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';
import 'package:kepleomax/core/presentation/user_image_widget.dart';
import 'package:kepleomax/core/presentation/channel_official_widget.dart';
import 'package:kepleomax/features/chats/bloc/chats_bloc.dart';
import 'package:kepleomax/features/chats/bloc/chats_state.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'widgets/chat_widget.dart';

part 'widgets/chat_message_widget.dart';

part 'widgets/chat_empty_message_widget.dart';

part 'widgets/chat_info_bottom_sheet.dart';

/// screen
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    context.read<ChatsBloc>().add(const ChatsEventLoadCache());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(key: Key('chats_app_bar')),
      body: _Body(key: Key('chats_body')),
    );
  }
}

/// body
class _Body extends StatelessWidget {
  const _Body({super.key});

  /// build
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsBloc, ChatsState>(
      buildWhen: (oldState, newState) {
        if (newState is! ChatsStateBase) return false;

        if (oldState is! ChatsStateBase) return true;

        return oldState.data != newState.data;
      },
      listener: (context, state) {
        if (state is ChatsStateMessage && !flavor.isRelease) {
          context.showSnackBar(
            text: state.message,
            color: state.isError ? KlmColors.errorRed : null,
          );
        }
      },
      builder: (context, state) {
        if (state is ChatsStateError) {
          return KlmErrorWidget(
            errorMessage: state.message,
            onRetry: () {
              context.read<ChatsBloc>().add(const ChatsEventLoad());
            },
          );
        }

        if (state is! ChatsStateBase) return const SizedBox();

        final data = state.data;
        if (data.isLoading && data.chats.isEmpty) {
          return RefreshIndicator(
            key: const Key('chats_loading'),
            onRefresh: () async {
              context.read<ChatsBloc>().add(const ChatsEventReconnect());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Skeletonizer(
                child: Column(
                  children: [
                    ChatWidget(chat: Chat.loading()),
                    ChatWidget(chat: Chat.loading()),
                    ChatWidget(chat: Chat.loading()),
                    ChatWidget(chat: Chat.loading()),
                    ChatWidget(chat: Chat.loading()),
                  ],
                ),
              ),
            ),
          );
        }

        if (data.chats.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ChatsBloc>().add(const ChatsEventLoad());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have no chats now',
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        KlmTextButton(
                          key: const Key('find_people_button'),
                          onPressed: () {
                            AppNavigator.of(context)!.push(const PeoplePage());
                          },
                          width: 200,
                          text: 'Find people',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (!data.isConnected) {
              context.read<ChatsBloc>().add(const ChatsEventReconnect());
            } else {
              context.read<ChatsBloc>().add(const ChatsEventLoad());
            }
          },
          child: ListView.builder(
            key: const Key('chats_list_view'),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: data.chats.length,
            itemBuilder: (context, i) => ChatWidget(
              key: Key('chat_${data.chats[i].id}'),
              chat: data.chats[i],
            ),
          ),
        );
      },
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      buildWhen: (oldState, newState) {
        if (newState is! ChatsStateBase) return false;

        if (oldState is! ChatsStateBase) return true;

        return oldState.data.isLoading != newState.data.isLoading ||
            oldState.data.isConnected != newState.data.isConnected;
      },
      builder: (context, state) {
        if (state is! ChatsStateBase) return const SizedBox();

        final data = state.data;
        return KlmAppBar(
          context,
          !data.isConnected
              ? 'Connecting...'
              : data.isLoading
              ? 'Updating...'
              : 'Chats',
          // TODO is flavor good here?
          showLoading: (!data.isConnected || data.isLoading) && !flavor.isTesting,
          actions: [
            PopupMenuButton<ChatsAppBarCreateActions>(
              icon: const Icon(Icons.create_new_folder_outlined),
              onSelected: (value) {
                switch (value) {
                  case ChatsAppBarCreateActions.channel:
                    AppNavigator.push(context, ChannelEditorPage(channelData: null));
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: ChatsAppBarCreateActions.channel,
                  child: Text('Create channel'),
                ),
              ],
            ),
          ],
          key: const Key('chats_app_bar'),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

enum ChatsAppBarCreateActions { channel }
