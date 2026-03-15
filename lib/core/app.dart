import 'package:flutter/material.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/unfocus_widget.dart';
import 'package:kepleomax/core/scopes/auth_scope.dart';
import 'package:kepleomax/core/scopes/calls_scope.dart';
import 'package:kepleomax/core/scopes/messenger_scope.dart';
import 'package:kepleomax/core/scopes/user_activity_scope.dart';

final mainNavigatorGlobalKey = GlobalKey<AppNavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: KlmColors.primaryColor),
      ),
      themeMode: ThemeMode.light,
      builder: (context, _) {
        return UnfocusWidget(
          child: AuthScope(
            builder: (context, userId) => MessengerScope(
              child: UserActivityScope(
                child: CallsScope(
                  child: AppNavigator(
                    initialState: const [MainPage()],
                    navigatorKey: mainNavigatorKey,
                    key: mainNavigatorGlobalKey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
