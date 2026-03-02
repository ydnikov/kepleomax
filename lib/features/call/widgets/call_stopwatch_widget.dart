import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';

class CallStopwatchWidget extends StatefulWidget {
  const CallStopwatchWidget({
    required this.callStartedTime,
    this.color = Colors.white,
    super.key,
  });

  final DateTime callStartedTime;
  final Color color;

  @override
  State<CallStopwatchWidget> createState() => _CallStopwatchWidgetState();
}

class _CallStopwatchWidgetState extends State<CallStopwatchWidget> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 900), (_) {
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
  Widget build(BuildContext context) {
    return Text(
      ParseTime.toStopwatch(DateTime.now().difference(widget.callStartedTime)),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: widget.color,
      ),
    );
  }
}
