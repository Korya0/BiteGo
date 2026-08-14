import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorite_food_card.dart';
import 'package:flutter/material.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({
    required this.favorites,
    required this.onFavoriteTap,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    super.key,
  });

  final List<FavoriteModel> favorites;
  final void Function(FavoriteModel favorite) onFavoriteTap;
  final bool isSelectionMode;
  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: context.screenPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.space.smMd,
        mainAxisSpacing: context.space.smMd,
        childAspectRatio: 0.62,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return FavoriteFoodCard(
          favorite: favorite,
          isSelectionMode: isSelectionMode,
          isSelected: selectedIds.contains(favorite.id),
          onTap: () => onFavoriteTap(favorite),
        );
      },
    );
  }
}