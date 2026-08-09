import 'package:bite_go/core/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: context.color.iconText,
      ),
    );
  }
}
