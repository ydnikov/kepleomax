part of '../user_screen.dart';

class AutoScrollControllerListeners extends StatefulWidget {
  const AutoScrollControllerListeners({
    required this.controller,
    required this.onLoadMore,
    required this.child,
    this.scrollDown = true,
    this.maxWorkingDistance = 125,
    super.key,
  });

  final AutoScrollController controller;
  final VoidCallback onLoadMore;
  final Widget child;
  final int maxWorkingDistance;
  final bool scrollDown;

  @override
  State<AutoScrollControllerListeners> createState() =>
      _AutoScrollControllerListenersState();
}

class _AutoScrollControllerListenersState extends State<AutoScrollControllerListeners> {

  /// callbacks
  @override
  void initState() {
    widget.controller.addListener(_onScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScrollListener);
    super.dispose();
  }

  /// listeners
  void _onScrollListener() {
    if (widget.controller.offset >
        widget.controller.position.maxScrollExtent - 180) {
      widget.onLoadMore();
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final offset = widget.controller.offset;
      final edge = widget.maxWorkingDistance ~/ 2 + 10;
      if (offset > 0 && offset <= edge) {
        widget.controller.scrollToIndex(0, preferPosition: AutoScrollPosition.end);
      } else if (offset > edge && offset < widget.maxWorkingDistance && widget.scrollDown) {
        widget.controller.scrollToIndex(1, preferPosition: AutoScrollPosition.begin);
      }
    }
    return false;
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: widget.child,
    );
  }
}