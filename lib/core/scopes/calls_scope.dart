import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/services/calls_service.dart';

class CallsScope extends StatefulWidget {
  const CallsScope({required this.child, super.key});

  final Widget child;

  @override
  State<CallsScope> createState() => _CallsScopeState();
}

class _CallsScopeState extends State<CallsScope> {
  late final Dependencies _dp;

  @override
  void initState() {
    _dp = Dependencies.of(context);
    CallsService.instance.subscribeOnEvents(_dp.rtcWebSocket, _dp.userRepository);

    super.initState();
  }

  @override
  void dispose() {
    CallsService.instance.unsubscribeFromEvents();

    super.dispose();
  }

  void _onResume() {
    CallsService.instance.checkActiveCalls(_dp.userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onForegroundGained: _onResume,
      onVisibilityGained: _onResume,
      child: widget.child,
    );
  }
}
