import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/food_card.dart';
import 'package:flutter/material.dart';

class FavoriteFoodCard extends StatelessWidget {
  const FavoriteFoodCard({
    required this.favorite,
    required this.onTap,
    this.isSelectionMode = false,
    this.isSelected = false,
    super.key,
  });

  final FavoriteModel favorite;
  final VoidCallback onTap;
  final bool isSelectionMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          AbsorbPointer(
            absorbing: isSelectionMode,
            child: FoodCard(food: favorite.food),
          ),
          if (isSelectionMode)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.color.iconBlack.withValues(
                    alpha: isSelected
                        ? context.opacity.low
                        : context.opacity.disabled,
                  ),
                  borderRadius: BorderRadius.circular(context.radius.lg),
                ),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: EdgeInsets.all(context.space.sm),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: context.iconSize.lg,
                      color: isSelected
                          ? context.color.primary
                          : context.color.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}