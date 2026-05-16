import 'dart:async';

import 'package:flutter/material.dart';

class EllipsisTextWidget extends StatefulWidget {
  const EllipsisTextWidget(
    this.text, {
    this.style,
    this.ellipsis = true,
    this.textKey,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final bool ellipsis;
  final TextAlign? textAlign;
  final Key? textKey;

  @override
  State<EllipsisTextWidget> createState() => _EllipsisTextWidgetState();
}

class _EllipsisTextWidgetState extends State<EllipsisTextWidget> {
  late final Timer _timer;
  int _dotsCount = 0;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (_dotsCount == 3) {
        _dotsCount = 0;
      } else {
        _dotsCount += 1;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
    _text,
    style: widget.style,
    textAlign: widget.textAlign,
    key: widget.textKey,
  );

  String get _text {
    if (!widget.ellipsis) return widget.text;

    final sb = StringBuffer(widget.text);
    for (int i = 0; i < _dotsCount; i++) {
      sb.write('.');
    }
    return sb.toString();
  }
}
