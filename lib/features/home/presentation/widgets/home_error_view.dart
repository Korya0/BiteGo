import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class HomeErrorView extends StatelessWidget {
  const HomeErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyle.body.copyWith(
                color: context.color.textSecondary,
              ),
            ),
            AppGap.h(context.space.lg),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.homeRetry,
                style: context.textStyle.subtitle.copyWith(
                  color: context.color.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
