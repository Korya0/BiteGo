import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  const AppToast._();

  static void show({
    required BuildContext context,
    required String message,
  }) {
    toastification.dismissAll(delayForAnimation: false);

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: false,
      showIcon: false,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      title: Text(
        message,
        style: context.textStyle.subtitle.copyWith(
          fontSize: context.fontSize.sm,
          color: context.color.textOnPrimary,
        ),
      ),
      primaryColor: context.color.primary,
      backgroundColor: context.color.primary,
      foregroundColor: context.color.textOnPrimary,
      boxShadow: const [],
      margin: EdgeInsets.symmetric(
        horizontal: context.space.md,
        vertical: context.space.sm,
      ),
    );
  }
}
