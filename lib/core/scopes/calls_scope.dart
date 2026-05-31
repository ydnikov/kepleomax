import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/di/singleton_dependencies_provider.dart';
import 'package:kepleomax/core/network/websockets/rtc_web_socket.dart';
import 'package:kepleomax/core/services/calls_service.dart';

class CallsScope extends StatefulWidget {
  const CallsScope({required this.child, super.key});

  final Widget child;

  @override
  State<CallsScope> createState() => _CallsScopeState();
}

class _CallsScopeState extends State<CallsScope> {
  late final Dependencies _dp;
  late final RtcWebSocket _rtcWebSocket;

  @override
  void initState() {
    _dp = Dependencies.of(context);
    _rtcWebSocket = _dp.rtcWebSocketBuilder();
    CallsService.instance.subscribeOnEvents(
      rtsWebSocket: _rtcWebSocket,
      userRepository: _dp.userRepository,
      callsApi: _dp.callsApi,
    );

    super.initState();
  }

  @override
  void dispose() {
    CallsService.instance.unsubscribeFromEvents();
    _rtcWebSocket.dispose();

    super.dispose();
  }

  void _onResume() {
    CallsService.instance.checkActiveCalls(_dp.userRepository, _dp.callsApi);
  }

  @override
  Widget build(BuildContext context) {
    return SingletonDependenciesProvider(
      providers: {RtcWebSocket: () => _rtcWebSocket},
      child: FocusDetector(
        onForegroundGained: _onResume,
        onVisibilityGained: _onResume,
        child: widget.child,
      ),
    );
  }
}
