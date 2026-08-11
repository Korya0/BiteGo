import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.textStyle.title.copyWith(
            fontSize: context.space.fontSizeXxl,
            color: context.color.textPrimary,
          ),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          AppGap.h(context.space.xs),
          Text(
            subtitle!,
            style: context.textStyle.body.copyWith(
              fontSize: context.space.fontSizeSm,
              color: context.color.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
