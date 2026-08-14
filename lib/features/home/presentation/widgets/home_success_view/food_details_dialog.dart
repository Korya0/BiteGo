import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_toast.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/price_formatter.dart';
import 'package:bite_go/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/cubit/food_details_cubit.dart';
import 'package:bite_go/features/home/presentation/cubit/food_details_state.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/quantity_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showFoodDetailsDialog(
  BuildContext context,
  FoodModel food,
) {
  return showDialog<void>(
    context: context,
    builder: (context) => BlocProvider(
      create: (context) => getIt<FavoritesCubit>(),
      child: FoodDetailsDialog(food: food),
    ),
  );
}

class FoodDetailsDialog extends StatelessWidget {
  const FoodDetailsDialog({required this.food, super.key});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(context.space.md),
      child: BlocProvider(
        create: (context) => FoodDetailsCubit(food: food),
        child: BlocBuilder<FoodDetailsCubit, FoodDetailsState>(
          builder: (context, state) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(context.radius.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.85,
                ),
                child: Material(
                  color: context.color.backgroundPrimary,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DialogHeader(imageUrl: state.food.imageUrl, food: state.food),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            context.space.md,
                            context.space.lg,
                            context.space.md,
                            context.space.xl,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DialogInfo(food: state.food),
                              AppGap.h(context.space.xl),
                              _DialogQuantity(
                                quantity: state.quantity,
                                onIncrement: () =>
                                    context.read<FoodDetailsCubit>().increment(),
                                onDecrement: () =>
                                    context.read<FoodDetailsCubit>().decrement(),
                              ),
                              AppGap.h(context.space.xl),
                              _DialogAddToCart(
                                food: state.food,
                                quantity: state.quantity,
                                totalPrice: state.food.price * state.quantity,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.imageUrl, required this.food});

  final String imageUrl;
  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isEmpty)
            ColoredBox(
              color: context.color.backgroundSecondary,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: context.color.iconSecondary,
                  size: context.iconSize.xxl,
                ),
              ),
            )
          else
            ImageWithShimmer(imageUrl: imageUrl),
          Positioned(
            top: context.space.md,
            right: context.space.md,
            child: Row(
              children: [
                _FavoriteToggleButton(food: food),
                AppGap.w(context.space.sm),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    backgroundColor: context.color.backgroundPrimary.withValues(
                      alpha: context.opacity.high,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: context.color.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteToggleButton extends StatelessWidget {
  const _FavoriteToggleButton({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesSuccess &&
            state.isFavorite(food.id);
        return GestureDetector(
          onTap: () async {
            final cubit = context.read<FavoritesCubit>();
            await cubit.toggleFavorite(food);
            if (!context.mounted) {
              return;
            }
            AppToast.show(
              context: context,
              message: isFavorite
                  ? '${food.name} ${AppStrings.favoritesRemoved}'
                  : '${food.name} ${AppStrings.favoritesAdded}',
            );
          },
          child: CircleAvatar(
            backgroundColor: context.color.backgroundPrimary.withValues(
              alpha: context.opacity.high,
            ),
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFavorite
                  ? context.color.primary
                  : context.color.textPrimary,
            ),
          ),
        );
      },
    );
  }
}

class _DialogInfo extends StatelessWidget {
  const _DialogInfo({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                food.name,
                style: context.textStyle.title.copyWith(
                  fontSize: context.fontSize.titleSm,
                  color: context.color.textPrimary,
                ),
              ),
            ),
            AppGap.w(context.space.sm),
            _RatingBadge(rating: food.rating),
          ],
        ),
        AppGap.h(context.space.sm),
        Text(
          formatPrice(food.price, withUnit: true),
          style: context.textStyle.title.copyWith(
            fontSize: context.fontSize.xl,
            color: context.color.primary,
          ),
        ),
        AppGap.h(context.space.md),
        Text(
          food.description,
          style: context.textStyle.body.copyWith(
            fontSize: context.fontSize.md,
            color: context.color.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DialogQuantity extends StatelessWidget {
  const _DialogQuantity({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppStrings.foodDetailsQuantity,
          style: context.textStyle.subtitle.copyWith(
            fontSize: context.fontSize.md,
            color: context.color.textPrimary,
          ),
        ),
        const Spacer(),
        QuantityControl(
          quantity: quantity,
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }
}

class _DialogAddToCart extends StatelessWidget {
  const _DialogAddToCart({
    required this.food,
    required this.quantity,
    required this.totalPrice,
  });

  final FoodModel food;
  final int quantity;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      text: '${AppStrings.foodDetailsAddToCart} — ${formatPrice(totalPrice, withUnit: true)}',
      onPressed: () {
        getIt<CartCubit>().addItem(food, quantity: quantity);
        AppToast.show(
          context: context,
          message: '${food.name} ${AppStrings.cartAddedToCart}',
        );
        Navigator.of(context).pop();
      },
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.starYellow.withValues(alpha: context.opacity.low),
        borderRadius: BorderRadius.circular(context.radius.sm),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.space.sm,
          vertical: context.space.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              size: context.iconSize.xsSm,
              color: context.color.starYellow,
            ),
            AppGap.w(context.space.xs),
            Text(
              rating.toStringAsFixed(1),
              style: context.textStyle.subtitle.copyWith(
                fontSize: context.fontSize.sm,
                color: context.color.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
