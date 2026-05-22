import 'package:flutter/material.dart';

class ChannelOfficialIconWidget extends StatelessWidget {
  const ChannelOfficialIconWidget({
    required this.leftWidget,
    required this.isOfficial,
    super.key,
  });

  final Widget leftWidget;
  final bool isOfficial;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leftWidget,
        if (isOfficial) ...[
          const SizedBox(width: 4),
          const Icon(Icons.star),
        ],
      ],
    );
  }
}
