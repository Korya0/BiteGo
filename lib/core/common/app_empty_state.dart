import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.assetPath,
    required this.message,
    this.title,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final String assetPath;
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.space.symmetric(horizontal: context.space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(assetPath),
            AppGap.h(context.space.lg),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: context.textStyle.title.copyWith(
                  fontSize: context.fontSize.xxl,
                  color: context.color.textPrimary,
                ),
              ),
              AppGap.h(context.space.md),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyle.body.copyWith(
                fontSize: context.fontSize.sm,
                color: context.color.textSecondary,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              AppGap.h(context.space.xl),
              AppButton.primary(
                text: actionLabel!,
                onPressed: onActionPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
