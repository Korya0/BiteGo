import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/favorites/data/models/favorite_model.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorites_content.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoritesLoadingView extends StatelessWidget {
  const FavoritesLoadingView({super.key});

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
        child: FavoritesContent(
          favorites: _skeletonFavorites,
          onFavoriteTap: (_) {},
        ),
      ),
    );
  }
}

final List<FavoriteModel> _skeletonFavorites = List.generate(
  4,
  (index) => FavoriteModel(
    food: FoodModel(
      id: 'skeleton-favorite-$index',
      name: 'Food name',
      description: 'Short description',
      imageUrl: '',
      price: 12000,
      rating: 4.8,
      categoryId: 'skeleton-cat',
      isAvailable: true,
      sortOrder: index,
    ),
    addedAt: DateTime(2026, 1, 1),
  ),
);