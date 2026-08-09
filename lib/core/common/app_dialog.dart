import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialog {
  const AppDialog._();

  static Future<T?> showInfo<T>({
    required BuildContext context,
    required String message,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: context.color.backgroundSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius.lg),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: context.space.lg),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.space.md,
              horizontal: context.space.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.textStyle.body.copyWith(
                    fontSize: 16,
                    color: context.color.textPrimary,
                  ),
                ),
                AppGap.h(context.space.lg),
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    text: AppStrings.ok,
                    onPressed: () => context.pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
