import 'package:flutter/material.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';

import 'package:kepleomax/core/presentation/klm_button.dart' show KlmButton;

class KlmErrorWidget extends StatelessWidget {
  const KlmErrorWidget({required this.errorMessage, this.onRetry, super.key});

  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 10),
              KlmButton(onPressed: onRetry, text: 'Retry', width: 120),
            ],
          ],
        ),
      ),
    );
  }
}
