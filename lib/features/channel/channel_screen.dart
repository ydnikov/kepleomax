import 'package:flutter/material.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/channel_image_widget.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';
import 'package:kepleomax/core/presentation/user_image_widget.dart';
import 'package:kepleomax/features/channel/widgets/delete_channel_dialog.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:kepleomax/features/user/user_screen.dart';
import 'package:num_remap/num_remap.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

const int _appBarNameFullShownOffset = 130;

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

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
    return Scaffold(
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
            child: Text(
              'Channel name',
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
          Text('123 subsribers', style: TextStyle(fontSize: 14, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: KlmTextButton(
                        onPressed: () {
                          AppNavigator.push(context, const ChannelEditorPage());
                        },
                        text: 'Edit',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KlmTextButton(
                        onPressed: () {
                          AppNavigator.showGeneralDialog(
                            context,
                            const DeleteChannelDialog(),
                            barrierDismissible: true,
                          );
                        },
                        text: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const Text(
                  'description:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standart',
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'share link:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'https://kepleomax.com/mycoolchannel',
                          style: TextStyle(
                            color: Color(0xFF2064CC),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 34,
                      margin: const EdgeInsets.only(top: 10),
                      child: IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        icon: const Icon(Icons.copy, color: Colors.blue, size: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
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
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (context, i) => _UserWidget(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _UserWidget extends StatelessWidget {
  const _UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Row(
        children: [
          ClipOval(
            child: SizedBox(height: 40, width: 40, child: UserDefaultIconWidget()),
          ),
          const SizedBox(width: 8),
          Text('Username'),
        ],
      ),
      contentPadding: const EdgeInsets.only(left: 16),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.clear, color: Colors.red),
      ),
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
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share))],
      centerTitle: true,
      title: Opacity(
        opacity: !widget.scrollController.hasClients
            ? 0
            : widget.scrollController.offset
                  .remap(110, _appBarNameFullShownOffset, 0, 1)
                  .clamp(0, 1),
        child: Text(
          'Channel name',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
