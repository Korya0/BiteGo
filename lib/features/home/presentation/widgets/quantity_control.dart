import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ControlButton(
          icon: Icons.remove_rounded,
          onTap: quantity > 1 ? onDecrement : null,
        ),
        AppGap.w(context.space.md),
        Text(
          '$quantity',
          style: context.textStyle.title.copyWith(
            fontSize: context.space.fontSizeLg,
            color: context.color.textPrimary,
          ),
        ),
        AppGap.w(context.space.md),
        _ControlButton(
          icon: Icons.add_rounded,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isEnabled
              ? context.color.primary
              : context.color.disabledButtonBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: context.color.textOnPrimary,
        ),
      ),
    );
  }
}
