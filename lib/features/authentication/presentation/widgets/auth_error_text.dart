import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class AuthErrorText extends StatelessWidget {
  const AuthErrorText({
    this.message,
    super.key,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message?.trim();
    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: context.space.sm),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: context.textStyle.caption.copyWith(
            fontSize: context.space.fontSizeSm,
            color: context.color.error,
          ),
        ),
      ),
    );
  }
}
