import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/cart/data/models/cart_item.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_state.dart';
import 'package:bite_go/features/cart/presentation/widgets/cart_success_view.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartLoadingView extends StatelessWidget {
  const CartLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          baseColor: context.color.shimmerBase,
          highlightColor: context.color.shimmerHighlight,
        ),
      ),
      child: Skeletonizer(
        child: CartSuccessView(
          state: CartSuccess(items: _skeletonItems),
          onIncrement: (_) {},
          onDecrement: (_) {},
          onRemove: (_) {},
          onOrderNow: () {},
        ),
      ),
    );
  }
}

final List<CartItem> _skeletonItems = List.generate(
  2,
  (index) => CartItem(
    food: FoodModel(
      id: 'skeleton-cart-$index',
      name: 'Food name',
      description: 'Short description',
      imageUrl: '',
      price: 12000,
      rating: 4.8,
      categoryId: 'skeleton-cat',
      isAvailable: true,
      sortOrder: index,
    ),
    quantity: 1,
  ),
);
