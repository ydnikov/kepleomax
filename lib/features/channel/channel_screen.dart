import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/channel_image_widget.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';
import 'package:kepleomax/core/presentation/user_image_widget.dart';
import 'package:kepleomax/features/channel/bloc/channel_bloc.dart';
import 'package:kepleomax/features/channel/bloc/channel_state.dart';
import 'package:kepleomax/features/channel/data/channel_repository.dart';
import 'package:kepleomax/features/channel/widgets/delete_channel_dialog.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:kepleomax/features/user/user_screen.dart';
import 'package:num_remap/num_remap.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

part 'widgets/channel_buttons_widget.dart';

part 'widgets/channel_user_widget.dart';

const int _appBarNameFullShownOffset = 130;

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({required this.channelData, super.key});

  final ChannelData channelData;

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  final _scrollController = AutoScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChannelBloc>(
      create: (context) => ChannelBloc(
        channelData: widget.channelData,

        /// should be opened from chat_screen, for having this in dp
        channelRepository: Dependencies.of(context).read<ChannelRepository>(),
      )..add(const ChannelEventLoad()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _AppBar(scrollController: _scrollController),
        body: SafeArea(
          top: false,
          child: AutoScrollControllerListeners(
            controller: _scrollController,
            maxWorkingDistance: 220,
            scrollDown: false,
            onLoadMore: () {},
            child: _Body(
              scrollController: _scrollController,
              scrollTopPadding: MediaQuery.of(context).viewPadding.top,
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.scrollController, required this.scrollTopPadding});

  final AutoScrollController scrollController;
  final double scrollTopPadding;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChannelBloc, ChannelState>(
      listener: (context, state) {
        if (state is ChannelStateMessage) {
          context.showSnackBar(
            text: state.message,
            color: state.isError ? Colors.red : Colors.black,
          );
        }
      },
      buildWhen: (oldState, newState) {
        if (newState is! ChannelStateBase) return false;

        if (oldState is! ChannelStateBase) return true;

        return oldState.data != newState.data;
      },
      builder: (context, state) {
        if (state is! ChannelStateBase) return const SizedBox();
        final data = state.data;
        final channelData = data.channelData;

        return SingleChildScrollView(
          controller: widget.scrollController,
          padding: EdgeInsets.only(top: widget.scrollTopPadding),
          child: Column(
            children: [
              AutoScrollTag(
                key: const Key('top_scroll_tag'),
                controller: widget.scrollController,
                index: 0,
                child: const ChannelDefaultIconWidget(size: 130),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SelectableText(
                  channelData.name,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              // AutoScrollTag(
              //   key: const Key('bottom_of_name_scroll_tag'),
              //   controller: widget.scrollController,
              //   index: 1,
              //   child:
              // ),
              const SizedBox(height: 2),
              Skeletonizer(
                enabled: channelData.subscribersCount == null,
                child: Text(
                  '${channelData.subscribersCount ?? 0} subscriber${ParseTime.isSingular(channelData.subscribersCount ?? 0) ? '' : 's'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChannelButtonsWidget(
                      channelData: channelData,
                      isLoading: data.isLoading,
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const Text(
                      'description:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    if (channelData.description.isNotEmpty)
                      SelectableText(channelData.description)
                    else
                      const Text(
                        'Empty description',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'share link:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: context.screenSize.width * 0.75,
                              child: SelectableText(
                                data.channelData.fullTag,
                                style: const TextStyle(
                                  color: KlmColors.link,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 34,
                          margin: const EdgeInsets.only(top: 10),
                          child: IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: channelData.fullTag),
                              );
                            },
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.blue,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              if (channelData.userRole.isOwner) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Subscribers',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (data.subs.isNotEmpty)
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.subs.length,
                      itemBuilder: (context, i) => _ChannelUserWidget(
                        user: data.subs[i],
                        key: Key('channel_subscriber_${data.subs[i].id}'),
                        onDelete: () {
                          context.read<ChannelBloc>().add(
                            ChannelEventUnsubscribe(userId: data.subs[i].id),
                          );
                        },
                      ),
                    ),
                  )
                else if (data.isLoading)
                  Column(
                    children: [
                      _ChannelUserWidget(user: User.loading(), isLoading: true),
                      _ChannelUserWidget(user: User.loading(), isLoading: true),
                      _ChannelUserWidget(user: User.loading(), isLoading: true),
                    ],
                  )
                else
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Failed to load subscribers list :(',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      KlmTextButton(
                        onPressed: () {
                          context.read<ChannelBloc>().add(const ChannelEventLoad());
                        },
                        text: 'Retry',
                        width: 200,
                      ),
                    ],
                  ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar({required this.scrollController});

  final AutoScrollController scrollController;

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> {
  /// callbacks
  @override
  void initState() {
    widget.scrollController.addListener(_onScrolledListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrolledListener);
    super.dispose();
  }

  /// should be here, not in _ScrollControllerListeners cause setState
  /// must rebuild only this widget, not body
  /// listeners
  double _lastScrollPosition = 0;

  void _onScrolledListener() {
    final currentOffset = widget.scrollController.offset;

    /// cause you can scroll really fast and skip _appBarUsernameFullShownOffset offset
    if (currentOffset > _appBarNameFullShownOffset &&
        _lastScrollPosition > _appBarNameFullShownOffset) {
      return;
    }
    _lastScrollPosition = currentOffset;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelBloc, ChannelState>(
      buildWhen: (oldState, newState) {
        if (newState is! ChannelStateBase) return false;
        if (oldState is! ChannelStateBase) return true;

        return oldState.data.channelData.name != newState.data.channelData.name;
      },
      builder: (context, state) {
        if (state is! ChannelStateBase) return const SizedBox();
        final data = state.data;

        return AppBar(
          backgroundColor: Colors.white.withAlpha(
            !widget.scrollController.hasClients
                ? 0
                : widget.scrollController.offset
                      .remap(0, 90, 0, 255)
                      .clamp(0, 255)
                      .toInt(),
          ),
          surfaceTintColor: Colors.white,
          leading: const KlmBackButton(),
          actions: [
            IconButton(
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(text: data.channelData.fullTag),
                );
              },
              icon: const Icon(Icons.ios_share),
            ),
          ],
          centerTitle: true,
          title: Opacity(
            opacity: !widget.scrollController.hasClients
                ? 0
                : widget.scrollController.offset
                      .remap(110, _appBarNameFullShownOffset, 0, 1)
                      .clamp(0, 1),
            child: Text(
              data.channelData.name,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        );
      },
    );
  }
}
