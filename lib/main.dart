import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/di/initialize_dependencies.dart';
import 'package:kepleomax/core/error_app.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();

      // await FlutterCallkitIncoming.startCall(CallKitParams(
      //   id: 'init_id',
      //   nameCaller: 'Register',
      //   type: 1,
      // ));
      //
      // await FlutterCallkitIncoming.endAllCalls();

      final dependencies = await initializeDependencies();

      WidgetsFlutterBinding.ensureInitialized().allowFirstFrame();

      runApp(dependencies.inject(child: const App()));
    },
    (e, st) {
      logger.e('runZonedGuardedError: $e', stackTrace: st);

      if (flavor.isTesting) throw e;

      if (!WidgetsBinding.instance.sendFramesToEngine) {
        /// init was unsuccessful
        WidgetsFlutterBinding.ensureInitialized().allowFirstFrame();
        runApp(ErrorApp(error: e));
      }
    },
  );
}
