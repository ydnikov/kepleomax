import 'package:flutter/material.dart';
import 'package:kepleomax/core/di/dependencies.dart';

extension KlmUrlLauncherExtension on BuildContext {
  Future<void> launchUrl(Uri uri) =>
      Dependencies.of(this).klmUrlLauncher.launchKlmUrl(uri);
}