import 'package:flutter/material.dart';
import 'package:bite_go/core/utils/context_extension.dart';

enum AppButtonType { primary, secondary, outlined }

class AppButton extends StatefulWidget {
  const AppButton.primary({
    required this.text,
    super.key,
    this.onPressed,
    this.leading,
    this.trailing,
    this.isDisabled = false,
    this.isLoading = false,
  }) : type = AppButtonType.primary;
  const AppButton.secondary({
    required this.text,
    super.key,
    this.onPressed,
    this.leading,
    this.trailing,
    this.isDisabled = false,
    this.isLoading = false,
  }) : type = AppButtonType.secondary;
  const AppButton.outlined({
    required this.text,
    super.key,
    this.onPressed,
    this.leading,
    this.trailing,
    this.isDisabled = false,
    this.isLoading = false,
  }) : type = AppButtonType.outlined;

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisabled;
  final bool isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.isDisabled || widget.onPressed == null;
    final isLoading = widget.isLoading;
    final isPrimary = widget.type == AppButtonType.primary;
    final isSecondary = widget.type == AppButtonType.secondary;
    final isOutlined = widget.type == AppButtonType.outlined;

    Color bgColor;
    if (isPrimary) {
      bgColor = disabled && !isLoading
          ? context.color.disabledButtonBackground
          : context.color.primary;
    } else if (isSecondary) {
      bgColor = context.color.secondaryScaffoldBackgroundColor;
    } else {
      bgColor = context.color.scaffoldBackgroundColor;
    }

    final txtColor = isPrimary
        ? context.color.textOnPrimary
        : context.color.textPrimary;

    Border? border;
    if (isOutlined) {
      border = Border.all(color: context.color.disabledButtonBackground);
    }

    final verticalPadding = context.space.sm;
    final blocked = disabled || isLoading;

    Widget content;
    if (isLoading) {
      content = Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: txtColor,
          ),
        ),
      );
    } else {
      content = Stack(
        alignment: Alignment.center,
        children: [
          if (widget.leading != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: widget.leading,
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.space.xl),
            child: Text(
              widget.text,
              style: context.textStyle.subtitle.copyWith(
                fontSize: 15,
                color: txtColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.trailing != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: widget.trailing,
            ),
        ],
      );
    }

    return Listener(
      onPointerDown: blocked
          ? null
          : (_) {
              setState(() => _isPressed = true);
            },
      onPointerUp: blocked
          ? null
          : (_) {
              setState(() => _isPressed = false);
            },
      onPointerCancel: blocked
          ? null
          : (_) {
              setState(() => _isPressed = false);
            },
      child: GestureDetector(
        onTap: blocked ? null : widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
          opacity: _isPressed ? context.opacity.medium : 1.0,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(context.radius.md),
              border: border,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: context.space.md,
              ),
              child: IconTheme(
                data: IconThemeData(color: txtColor),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
