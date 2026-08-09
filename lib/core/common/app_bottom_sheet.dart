import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.color.bottomSheetBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.radius.lg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppGap.h(context.space.sm),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.color.textSecondary.withValues(
                        alpha: context.opacity.high,
                      ),
                      borderRadius: BorderRadius.circular(context.radius.xxl),
                    ),
                  ),
                  AppGap.h(context.space.lg),
                  child,
                  AppGap.h(context.space.xxl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
