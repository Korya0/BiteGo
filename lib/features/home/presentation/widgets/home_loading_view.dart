import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/home_success_view.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

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
        child: HomeSuccessView(
          banners: _skeletonBanners,
          categories: _skeletonCategories,
          foods: _skeletonFoods,
          selectedCategoryId: null,
          onCategorySelected: (_) {},
        ),
      ),
    );
  }
}

final List<BannerModel> _skeletonBanners = [
  BannerModel(
    id: 'skeleton-banner',
    imageUrl: '',
    sortOrder: 0,
    badge: 'Skeleton',
    title: 'Banner title',
    subtitle: 'Banner subtitle',
  ),
];

final List<CategoryModel> _skeletonCategories = [
  CategoryModel(id: 'skeleton-cat-1', name: 'Pizza', sortOrder: 1),
  CategoryModel(id: 'skeleton-cat-2', name: 'Burger', sortOrder: 2),
  CategoryModel(id: 'skeleton-cat-3', name: 'Salad', sortOrder: 3),
  CategoryModel(id: 'skeleton-cat-4', name: 'Drinks', sortOrder: 4),
];

final List<FoodModel> _skeletonFoods = List.generate(
  6,
  (index) => FoodModel(
    id: 'skeleton-food-$index',
    name: 'Food name',
    description: 'Short description',
    imageUrl: '',
    price: 12000,
    rating: 4.8,
    categoryId: 'skeleton-cat-1',
    isAvailable: true,
    sortOrder: index,
  ),
);
