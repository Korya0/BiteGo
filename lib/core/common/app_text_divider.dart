import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class AppTextDivider extends StatelessWidget {
  final String text;

  const AppTextDivider({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.color.textSecondary;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.space.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: color,
              thickness: 0.7,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.space.md),
            child: Text(
              text,
              style: context.textStyle.caption.copyWith(
                fontSize: 14,
                color: context.color.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: color,
              thickness: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
