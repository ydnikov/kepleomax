import 'package:flutter/material.dart';

class ChannelDefaultIconWidget extends StatelessWidget {
  const ChannelDefaultIconWidget({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColoredBox(
        color: Colors.grey.shade400,
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(Icons.ac_unit, size: size),
          ),
        ),
      ),
    );
  }
}
