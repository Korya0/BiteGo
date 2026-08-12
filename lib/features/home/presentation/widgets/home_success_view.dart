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
        if (banners.isNotEmpty)
          SliverToBoxAdapter(child: HomeBannerCarousel(banners: banners)),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeCategorySection(
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                onCategorySelected: onCategorySelected,
              ),
              if (foods.isEmpty)
                const _EmptyFoodsView()
              else ...[
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
                _FoodsGrid(foods: foods, isSkeleton: false),
              ],
            ],
          ),
        ),
       
       
        SliverToBoxAdapter(child: SizedBox(height: context.space.xl)),
      ],
    );
  }
}

class _EmptyFoodsView extends StatelessWidget {
  const _EmptyFoodsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.space.lg),
      child: Center(
        child: Column(
          children: [
            Text(
              AppStrings.homeSectionPopularFoods,
              style: context.textStyle.title.copyWith(
                fontSize: context.space.fontSizeLg,
                color: context.color.textPrimary,
              ),
            ),
            AppGap.h(context.space.sm),
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
    );
  }
}

class _FoodsGrid extends StatelessWidget {
  const _FoodsGrid({required this.foods, required this.isSkeleton});

  final List<FoodModel> foods;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: context.space.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.space.smMd,
        mainAxisSpacing: context.space.smMd,
        childAspectRatio: 0.62,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return FoodCard(food: foods[index], isSkeleton: isSkeleton);
      },
    );
  }
}
