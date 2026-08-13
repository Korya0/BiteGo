import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_toast.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_empty_view.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_loading_view.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            return switch (state) {
              CartLoading() => const CartLoadingView(),
              CartSuccess(:final items) => items.isEmpty
                  ? const CartEmptyView()
                  : CartSuccessView(
                      state: state,
                      onIncrement: (foodId) =>
                          context.read<CartCubit>().increment(foodId),
                      onDecrement: (foodId) =>
                          context.read<CartCubit>().decrement(foodId),
                      onRemove: (foodId) =>
                          context.read<CartCubit>().removeItem(foodId),
                      onOrderNow: () => AppToast.show(
                        context: context,
                        message: AppStrings.cartOrderPlaced,
                      ),
                    ),
            };
          },
        ),
      ),
    );
  }
}
