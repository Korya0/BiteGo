import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    required this.food,
    required this.onTap,
    super.key,
  });

  final FoodModel food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.backgroundPrimary,
          borderRadius: BorderRadius.circular(context.radius.lg),
          boxShadow: context.shadow.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.radius.lg),
                ),
                child: ImageWithShimmer(imageUrl: food.imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: context.textStyle.title.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF111111),
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const AppGap.h(4),
                  Text(
                    food.description,
                    style: context.textStyle.body.copyWith(
                      fontSize: 11,
                      color: const Color(0xFF999999),
                      height: 1.63,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const AppGap.h(8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 10,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        food.rating.toStringAsFixed(1),
                        style: context.textStyle.subtitle.copyWith(
                          fontSize: 11,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatPrice(food.price),
                        style: context.textStyle.title.copyWith(
                          fontSize: 13,
                          color: context.color.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final p = price.toInt();
    if (p >= 1000) {
      return '${(p / 1000).toStringAsFixed(p % 1000 == 0 ? 0 : 1)}k';
    }
    return '$p';
  }
}
