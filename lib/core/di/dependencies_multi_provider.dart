import 'package:flutter/material.dart';
import 'package:kepleomax/core/di/dependencies.dart';

class DependenciesMultiProvider extends StatefulWidget {
  const DependenciesMultiProvider({required this.providers, required this.child, super.key});

  final Map<Type, Object> providers;
  final Widget child;

  @override
  State<DependenciesMultiProvider> createState() =>
      _DependenciesMultiProviderState();
}

class _DependenciesMultiProviderState extends State<DependenciesMultiProvider> {
  late final Dependencies _dp;
  
  @override
  void initState() {
    _dp = Dependencies.of(context);
    _dp.provideAll(widget.providers);
    super.initState();
  }
  
  @override
  void dispose() {
    _dp.removeAll(widget.providers.keys.toList());
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
