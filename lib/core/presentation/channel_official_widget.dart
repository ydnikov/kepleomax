import 'package:flutter/material.dart';

class ChannelOfficialIconWidget extends StatelessWidget {
  const ChannelOfficialIconWidget({
    required this.leftWidget,
    required this.isOfficial,
    this.widthPadding = 4,
    super.key,
  });

  final Widget leftWidget;
  final double widthPadding;
  final bool isOfficial;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leftWidget,
        if (isOfficial) ...[
          SizedBox(width: widthPadding),
          const Icon(Icons.star),
        ],
      ],
    );
  }
}
