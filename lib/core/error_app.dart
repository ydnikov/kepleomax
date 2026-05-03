import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';

class ErrorApp extends StatelessWidget {
  const ErrorApp({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to initialize app:\n$error',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 10),
                  KlmTextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    width: 100,
                    text: 'Exit',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
