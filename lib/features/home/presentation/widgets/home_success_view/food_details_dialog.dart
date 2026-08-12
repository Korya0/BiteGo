import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
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
    builder: (context) => FoodDetailsDialog(food: food),
  );
}

String _formatPrice(double price) {
  final p = price.toInt();
  if (p >= 1000) {
    return '${(p / 1000).toStringAsFixed(p % 1000 == 0 ? 0 : 1)}k IQD';
  }
  return '$p IQD';
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
                      _DialogHeader(imageUrl: state.food.imageUrl),
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
  const _DialogHeader({required this.imageUrl});

  final String imageUrl;

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
                  size: context.space.iconXxl,
                ),
              ),
            )
          else
            ImageWithShimmer(imageUrl: imageUrl),
          Positioned(
            top: context.space.md,
            right: context.space.md,
            child: GestureDetector(
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
          ),
        ],
      ),
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
                  fontSize: context.space.fontSizeTitleSm,
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
          _formatPrice(food.price),
          style: context.textStyle.title.copyWith(
            fontSize: context.space.fontSizeXl,
            color: context.color.primary,
          ),
        ),
        AppGap.h(context.space.md),
        Text(
          food.description,
          style: context.textStyle.body.copyWith(
            fontSize: context.space.fontSizeMd,
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
            fontSize: context.space.fontSizeMd,
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
  const _DialogAddToCart({required this.food, required this.totalPrice});

  final FoodModel food;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      text: '${AppStrings.foodDetailsAddToCart} — ${_formatPrice(totalPrice)}',
      onPressed: () {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('${food.name} added to cart!')),
          );
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
              size: context.space.iconXsSm,
              color: context.color.starYellow,
            ),
            AppGap.w(context.space.xs),
            Text(
              rating.toStringAsFixed(1),
              style: context.textStyle.subtitle.copyWith(
                fontSize: context.space.fontSizeSm,
                color: context.color.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
