import 'package:flutter/material.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/connection_repository.dart';
import 'package:kepleomax/core/di/dependencies.dart';

class UserActivityScope extends StatefulWidget {
  const UserActivityScope({required this.child, super.key});

  final Widget child;

  /// findAncestorStateOfType will be null if user is not logged in
  static void addActivity(BuildContext context) =>
      context.findAncestorStateOfType<_UserActivityScopeState>()?.addActivity();

  @override
  State<UserActivityScope> createState() => _UserActivityScopeState();
}

class _UserActivityScopeState extends State<UserActivityScope> {
  late DateTime _lastTimeActivityDetectedSent;
  late final ConnectionRepository _connectionRepository;

  @override
  void initState() {
    _lastTimeActivityDetectedSent = DateTime.now();
    _connectionRepository = Dependencies.of(context).read<ConnectionRepository>();
    super.initState();
  }

  void addActivity() {
    if (_lastTimeActivityDetectedSent.millisecondsSinceEpoch +
            AppConstants.sendActivityDelay.inMilliseconds <
        DateTime.now().millisecondsSinceEpoch) {
      print('activity sent');
      _connectionRepository.activityDetected();
      _lastTimeActivityDetectedSent = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        addActivity();
      },
      child: widget.child,
    );
  }
}
