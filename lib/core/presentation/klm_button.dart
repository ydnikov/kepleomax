import 'package:flutter/material.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';

class KlmButton extends StatelessWidget {
  const KlmButton({
    required this.onPressed,
    required this.text,
    this.width,
    this.isLoading = false,
    super.key,
  });

  final double fontSize = 22;
  final double? width;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: KlmColors.primaryColor,
        // overlayColor: WidgetStateProperty.resolveWith<Color>((
        //   Set<WidgetState> states,
        // ) {
        //   if (states.contains(WidgetState.pressed)) {
        //     return WegaColors.activeButton;
        //   }
        //   return Colors.transparent;
        // }),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        fixedSize: Size(width ?? double.infinity, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: KlmColors.primaryColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                ),
              ),
      ),
    );
  }
}
