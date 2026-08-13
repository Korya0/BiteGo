import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/price_formatter.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/food_details_dialog.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({required this.food, this.isSkeleton = false, super.key});

  final FoodModel food;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSkeleton ? null : () => showFoodDetailsDialog(context, food),
      onLongPress:
          isSkeleton ? null : () => showFoodDetailsDialog(context, food),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.backgroundPrimary,
          borderRadius: BorderRadius.circular(context.radius.lg),
          boxShadow: context.shadow.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _CardImage(imageUrl: food.imageUrl)),
            _CardInfo(food: food),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.radius.lg),
      ),
      child: ImageWithShimmer(imageUrl: imageUrl),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.space.symmetric(
        horizontal: context.space.smMd,
        vertical: context.space.smXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            food.name,
            style: context.textStyle.title.copyWith(
              fontSize: context.fontSize.xsSm,
              color: context.color.textPrimaryStrong,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppGap.h(context.space.xs),
          Text(
            food.description,
            style: context.textStyle.body.copyWith(
              fontSize: context.fontSize.xxs,
              color: context.color.textTertiary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppGap.h(context.space.sm),
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: context.iconSize.xxs,
                color: context.color.starYellow,
              ),
              AppGap.w(context.space.xxs),
              Text(
                food.rating.toStringAsFixed(1),
                style: context.textStyle.subtitle.copyWith(
                  fontSize: context.fontSize.xxs,
                  color: context.color.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                formatPrice(food.price),
                style: context.textStyle.title.copyWith(
                  fontSize: context.fontSize.xsSm,
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
