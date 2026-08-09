import 'package:bite_go/core/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppTextDivider extends StatelessWidget {
  const AppTextDivider({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.space.md),
          child: Text(text),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
