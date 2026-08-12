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
                child: Image.network(
                  food.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => ColoredBox(
                    color: context.color.backgroundSecondary,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: context.color.iconSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.space.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: context.textStyle.subtitle.copyWith(
                      fontSize: context.space.fontSizeSm,
                      color: context.color.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.space.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: context.space.iconXs,
                        color: const Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        food.rating.toStringAsFixed(1),
                        style: context.textStyle.caption.copyWith(
                          fontSize: 11,
                          color: context.color.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatPrice(food.price),
                        style: context.textStyle.subtitle.copyWith(
                          fontSize: context.space.fontSizeSm,
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
