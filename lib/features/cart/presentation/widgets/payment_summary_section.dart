import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/price_formatter.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:flutter/material.dart';

class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({required this.state, super.key});

  final CartSuccess state;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.backgroundPrimary,
        borderRadius: BorderRadius.circular(context.radius.lg),
        border: Border.all(color: context.color.disabledButtonBackground),
      ),
      child: Padding(
        padding: context.space.all(context.space.smMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.cartPaymentSummary,
              style: context.textStyle.title.copyWith(
                fontSize: context.fontSize.md,
                color: context.color.textPrimary,
              ),
            ),
            AppGap.h(context.space.md),
            _SummaryRow(
              label: '${AppStrings.cartTotalItems} (${state.totalItems})',
              value: formatPrice(state.subtotal, withUnit: true),
            ),
            AppGap.h(context.space.md),
            const _SummaryRow(
              label: AppStrings.cartDeliveryFee,
              value: AppStrings.cartFree,
            ),
            AppGap.h(context.space.md),
            _SummaryRow(
              label: AppStrings.cartTotal,
              value: formatPrice(state.total, withUnit: true),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyle.body.copyWith(
            fontSize: context.fontSize.sm,
            color: emphasized
                ? context.color.textPrimary
                : context.color.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.textStyle.title.copyWith(
            fontSize: context.fontSize.sm,
            color: context.color.textPrimary,
          ),
        ),
      ],
    );
  }
}
