part of '../chat_screen.dart';

class _ReadButton extends StatefulWidget {
  const _ReadButton({
    required ScrollController scrollController,
    required this.chatId,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final int chatId;

  @override
  State<_ReadButton> createState() => _ReadButtonState();
}

class _ReadButtonState extends State<_ReadButton> {
  static const _offsetToShow = 200;
  double _lastPosition = 0;

  /// callbacks
  @override
  void initState() {
    widget._scrollController.addListener(_onScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget._scrollController.removeListener(_onScrollListener);
    super.dispose();
  }

  /// listeners
  void _onScrollListener() {
    if (_lastPosition < _offsetToShow &&
        widget._scrollController.offset > _offsetToShow) {
      setState(() {});
    } else if (_lastPosition > _offsetToShow &&
        widget._scrollController.offset < _offsetToShow) {
      setState(() {});
    }
    _lastPosition = widget._scrollController.offset;
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (oldState, newState) {
        if (newState is! ChatStateBase) return false;

        if (oldState is! ChatStateBase) return true;

        return oldState.data != newState.data;
      },
      builder: (context, state) {
        if (state is! ChatStateBase) return const SizedBox();

        final data = state.data;
        final unreadCount = data.chat.unreadCount;
        final isScrolledUp =
            widget._scrollController.positions.length == 1 &&
            widget._scrollController.offset > _offsetToShow;
        if (unreadCount < 0 && !flavor.isRelease) {
          logger.w('unreadCount < 0: $unreadCount');
        } else if (unreadCount <= 0 && !isScrolledUp) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 75),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                key: const Key('read_all_button'),
                shape: const CircleBorder(),
                elevation: 1,
                backgroundColor: Colors.white,
                isExtended: true,
                onPressed: data.isLoading || !data.isConnected
                    ? null
                    : () {
                        widget._scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                        if (unreadCount > 0) {
                          context.read<ChatBloc>().add(
                            const ChatEventReadAllMessages(),
                          );
                        }
                      },
                child: Transform.rotate(
                  angle: 270 * math.pi / 180,
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -14,
                  child: Container(
                    width: 35,
                    decoration: const BoxDecoration(
                      color: KlmColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Center(
                      child: Text(
                        unreadCount.toString(),
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
