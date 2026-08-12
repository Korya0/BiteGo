import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_snack_bar.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/food_details/presentation/cubit/food_details_cubit.dart';
import 'package:bite_go/features/food_details/presentation/cubit/food_details_state.dart';
import 'package:bite_go/features/food_details/presentation/widgets/quantity_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailsView extends StatelessWidget {
  const FoodDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: BlocBuilder<FoodDetailsCubit, FoodDetailsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _FoodDetailsAppBar(imageUrl: state.food.imageUrl),
              SliverToBoxAdapter(
                child: _FoodDetailsContent(state: state),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FoodDetailsAppBar extends StatelessWidget {
  const _FoodDetailsAppBar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: context.color.backgroundPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor:
              context.color.backgroundPrimary.withValues(alpha: 0.9),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: context.color.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrl.isEmpty
            ? ColoredBox(
                color: context.color.backgroundSecondary,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: context.color.iconSecondary,
                    size: 48,
                  ),
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: context.color.backgroundSecondary,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: context.color.iconSecondary,
                      size: 48,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _FoodDetailsContent extends StatelessWidget {
  const _FoodDetailsContent({required this.state});

  final FoodDetailsState state;

  @override
  Widget build(BuildContext context) {
    final food = state.food;
    final totalPrice = food.price * state.quantity;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.space.md,
        context.space.lg,
        context.space.md,
        context.space.xl + context.bottomSystemInset,
      ),
      child: Column(
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
              height: 1.5,
            ),
          ),
          AppGap.h(context.space.xl),
          Row(
            children: [
              Text(
                'Quantity',
                style: context.textStyle.subtitle.copyWith(
                  fontSize: context.space.fontSizeMd,
                  color: context.color.textPrimary,
                ),
              ),
              const Spacer(),
              QuantityControl(
                quantity: state.quantity,
                onIncrement: () =>
                    context.read<FoodDetailsCubit>().increment(),
                onDecrement: () =>
                    context.read<FoodDetailsCubit>().decrement(),
              ),
            ],
          ),
          AppGap.h(context.space.xl),
          AppButton.primary(
            text: 'Add to Cart — ${_formatPrice(totalPrice)}',
            onPressed: () => AppSnackBar.show(
              context: context,
              message: '${food.name} added to cart!',
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final p = price.toInt();
    if (p >= 1000) {
      return '${(p / 1000).toStringAsFixed(p % 1000 == 0 ? 0 : 1)}k IQD';
    }
    return '$p IQD';
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107).withValues(alpha: 0.15),
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
            const Icon(
              Icons.star_rounded,
              size: 16,
              color: Color(0xFFFFC107),
            ),
            const SizedBox(width: 4),
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
