import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/widgets/food_card.dart';
import 'package:bite_go/features/home/presentation/widgets/home_banner_carousel.dart';
import 'package:bite_go/features/home/presentation/widgets/home_category_section.dart';
import 'package:flutter/material.dart';

class HomeSuccessView extends StatelessWidget {
  const HomeSuccessView({
    required this.banners,
    required this.categories,
    required this.foods,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    super.key,
  });

  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<FoodModel> foods;
  final String? selectedCategoryId;
  final void Function(String? categoryId) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (banners.isNotEmpty) ...[
                HomeBannerCarousel(banners: banners),
                AppGap.h(context.space.md),
              ],
              HomeCategorySection(
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: onCategorySelected,
              ),
              AppGap.h(context.space.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.space.md),
                child: Text(
                  AppStrings.homeSectionPopularFoods,
                  style: context.textStyle.title.copyWith(
                    fontSize: context.space.fontSizeLg,
                    color: context.color.textPrimary,
                  ),
                ),
              ),
              AppGap.h(context.space.sm),
            ],
          ),
        ),
        _FoodsGrid(foods: foods, isSkeleton: false),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _FoodsGrid extends StatelessWidget {
  const _FoodsGrid({required this.foods, required this.isSkeleton});

  final List<FoodModel> foods;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(context.space.lg),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.no_food_rounded,
                  size: context.space.iconLg,
                  color: context.color.iconSecondary,
                ),
                AppGap.h(context.space.sm),
                Text(
                  AppStrings.homeEmptyFoods,
                  style: context.textStyle.body.copyWith(
                    color: context.color.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.space.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return FoodCard(food: foods[index], isSkeleton: isSkeleton);
          },
          childCount: foods.length,
        ),
      ),
    );
  }
}
