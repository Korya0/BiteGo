import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ??
              context.color.textOnPrimary.withValues(
                alpha: context.opacity.disabled,
              ),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(context.space.smXs),
          child: Icon(
            icon,
            size: context.iconSize.md,
            color: iconColor ?? context.color.iconBlack,
          ),
        ),
      ),
    );
  }
}