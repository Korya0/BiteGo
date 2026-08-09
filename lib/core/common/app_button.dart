import 'package:bite_go/core/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isEnabled = true,
    this.width = double.infinity,
    this.height = 56,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = isEnabled && !isLoading;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: effectiveEnabled ? onPressed : null,
        child: isLoading
            ? SizedBox(
                height: context.space.md,
                width: context.space.md,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.color.textOnPrimary,
                ),
              )
            : Text(text),
      ),
    );
  }
}
