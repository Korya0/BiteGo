import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_empty_state.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_snack_bar.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:bite_go/features/cart/presentation/widgets/payment_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.cartTitle),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return AppEmptyState(
                assetPath: AppAssets.svgsEmptyCart,
                title: AppStrings.cartEmptyTitle,
                message: AppStrings.cartEmptyMessage,
                actionLabel: AppStrings.cartFindFoods,
                onActionPressed: () => context.go(AppRoutes.search),
              );
            }
            return _CartContent(state: state);
          },
        ),
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({required this.state});

  final CartState state;

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
              onIncrement: () => context
                  .read<CartCubit>()
                  .increment(state.items[index].food.id),
              onDecrement: () => context
                  .read<CartCubit>()
                  .decrement(state.items[index].food.id),
              onRemove: () =>
                  context.read<CartCubit>().removeItem(state.items[index].food.id),
            ),
          ],
          AppGap.h(context.space.lg),
          PaymentSummarySection(state: state),
          AppGap.h(context.space.lg),
          AppButton.primary(
            text: AppStrings.cartOrderNow,
            onPressed: () => AppSnackBar.show(
              context: context,
              message: AppStrings.cartOrderPlaced,
            ),
          ),
        ],
      ),
    );
  }
}
