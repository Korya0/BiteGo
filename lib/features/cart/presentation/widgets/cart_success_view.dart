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
    return SingleChildScrollView(
      padding: context.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < state.items.length; index++) ...[
            if (index > 0) AppGap.h(context.space.smMd),
            CartItemCard(
              item: state.items[index],
              onIncrement: () => onIncrement(state.items[index].food.id),
              onDecrement: () => onDecrement(state.items[index].food.id),
              onRemove: () => onRemove(state.items[index].food.id),
            ),
          ],
          AppGap.h(context.space.lg),
          PaymentSummarySection(state: state),
          AppGap.h(context.space.lg),
          AppButton.primary(
            text: AppStrings.cartOrderNow,
            onPressed: onOrderNow,
          ),
        ],
      ),
    );
  }
}
