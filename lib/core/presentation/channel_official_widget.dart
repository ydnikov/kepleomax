import 'package:flutter/material.dart';

class ChannelOfficialIconWidget extends StatelessWidget {
  const ChannelOfficialIconWidget({
    required this.leftWidget,
    required this.isOfficial,
    this.widthPadding = 4,
    this.showHintOnTap = false,
    super.key,
  });

  final Widget leftWidget;
  final double widthPadding;
  final bool isOfficial;
  final bool showHintOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leftWidget,
        if (isOfficial) ...[
          SizedBox(width: widthPadding),
          Tooltip(
            message: 'Verified channel',
            triggerMode: showHintOnTap
                ? TooltipTriggerMode.tap
                : TooltipTriggerMode.manual,
            showDuration: const Duration(seconds: 3),
            child: const Icon(Icons.star),
          ),
        ],
      ],
    );
  }
}
