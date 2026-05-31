import 'package:flutter/material.dart';
import 'package:kepleomax/core/di/dependencies.dart';

/// if _dp already has the Type, builder won't be called
class SingletonDependenciesProvider extends StatefulWidget {
  const SingletonDependenciesProvider({
    required this.providers,
    required this.child,
    super.key,
  });

  final Map<Type, Object Function()> providers;
  final Widget child;

  @override
  State<SingletonDependenciesProvider> createState() =>
      _SingletonDependenciesProviderState();
}

class _SingletonDependenciesProviderState extends State<SingletonDependenciesProvider> {
  late final Dependencies _dp;

  @override
  void initState() {
    _dp = Dependencies.of(context);
    /// TODO make it better
    /// pass object to not initialize new instance. We can't just ignore it in
    /// case when dp already has that key, cause right this widget works strange,
    /// oldWidget dispose can be called after newWidget initState if state is
    /// recreated (in case when user goes from one screen to new instance of the same)
    final initProviders = widget.providers.map(
      (key, builder) =>
          MapEntry(key, _dp.hasByType(key) ? Object() : builder.call()),
    );
    _dp.provideAll(initProviders);
    super.initState();
  }

  @override
  void dispose() {
    _dp.removeAll(widget.providers.keys.toList());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
