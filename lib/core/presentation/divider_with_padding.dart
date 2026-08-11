import 'package:flutter/material.dart';

class DividerWithPadding extends StatelessWidget {
  const DividerWithPadding({required this.verticalPadding, super.key});

  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: const Divider(),
    );
  }
}
