import 'package:flutter/material.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';

class KlmTextButton extends StatelessWidget {
  const KlmTextButton({
    required this.onPressed,
    required this.text,
    this.width,
    this.backgroundColor = KlmColors.primaryColor,
    this.isLoading = false,
    this.enabled = true,
    this.fontSize = 16,
    super.key,
  });

  final double fontSize;
  final double? width;
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading || !enabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          // overlayColor: WidgetStateProperty.resolveWith<Color>((
          //   Set<WidgetState> states,
          // ) {
          //   if (states.contains(WidgetState.pressed)) {
          //     return WegaColors.activeButton;
          //   }
          //   return Colors.transparent;
          // }),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      ),
    );
  }
}
