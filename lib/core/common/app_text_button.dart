import 'package:flutter/material.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/common/app_gap.dart';

class AppTextButton extends StatefulWidget {
  const AppTextButton({
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final Widget? leading;
  final EdgeInsetsGeometry padding;

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final style =
        widget.textStyle ??
        context.textStyle.subtitle.copyWith(color: context.color.blue);

    Widget content = Text(widget.text, style: style);

    if (widget.leading != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.leading!,
          AppGap.w(context.space.xs),
          content,
        ],
      );
    }

    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: widget.padding,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            opacity: _isPressed ? context.opacity.low : 1.0,
            child: content,
          ),
        ),
      ),
    );
  }
}
