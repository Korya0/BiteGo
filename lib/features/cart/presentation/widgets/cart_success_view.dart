import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:bite_go/features/cart/presentation/widgets/payment_summary_section.dart';
import 'package:flutter/material.dart';

class CartSuccessView extends StatelessWidget {
  const CartSuccessView({
    required this.state,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onOrderNow,
    super.key,
  });

  final CartSuccess state;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<String> onRemove;
  final VoidCallback onOrderNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              context.space.md,
              context.space.md,
              context.space.md,
              context.space.lg,
            ),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemCard(
                item: item,
                onIncrement: () => onIncrement(item.food.id),
                onDecrement: () => onDecrement(item.food.id),
                onRemove: () => onRemove(item.food.id),
              );
            },
            separatorBuilder: (context, index) =>
                AppGap.h(context.space.smMd),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.color.backgroundPrimary,
            border: Border(
              top: BorderSide(color: context.color.disabledButtonBackground),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.space.md,
              context.space.md,
              context.space.md,
              context.space.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaymentSummarySection(state: state),
                AppGap.h(context.space.md),
                AppButton.primary(
                  text: AppStrings.cartOrderNow,
                  onPressed: onOrderNow,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
