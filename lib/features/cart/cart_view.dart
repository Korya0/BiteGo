import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

/// Placeholder for the Cart tab until the feature is built.
class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          AppStrings.bottomNavCart,
          style: context.textStyle.title.copyWith(
            fontSize: context.fontSize.xl,
            color: context.color.textSecondary,
          ),
        ),
      ),
    );
  }
}
