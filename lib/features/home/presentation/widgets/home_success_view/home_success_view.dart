import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_icon_button.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/home_banner_section.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/home_content_section.dart';
import 'package:flutter/material.dart';

class HomeSuccessView extends StatelessWidget {
  const HomeSuccessView({
    required this.banners,
    required this.categories,
    required this.foods,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.onSearchPressed,
    this.onFavoritesPressed,
    super.key,
  });

  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<FoodModel> foods;
  final String? selectedCategoryId;
  final void Function(String? categoryId) onCategorySelected;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onFavoritesPressed;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (banners.isNotEmpty)
          SliverToBoxAdapter(
            child: Stack(
              children: [
                HomeBannerSection(banners: banners),
                if (onSearchPressed != null || onFavoritesPressed != null)
                  Positioned(
                    top: context.space.md,
                    right: context.space.md,
                    child: Row(
                      children: [
                        if (onFavoritesPressed != null) ...[
                          AppIconButton(
                            onPressed: onFavoritesPressed!,
                            icon: Icons.favorite_border_rounded,
                          ),
                          AppGap.w(context.space.sm),
                        ],
                        if (onSearchPressed != null)
                          AppIconButton(
                            onPressed: onSearchPressed!,
                            icon: Icons.search_rounded,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        SliverToBoxAdapter(
          child: HomeContentSection(
            categories: categories,
            foods: foods,
            selectedCategoryId: selectedCategoryId,
            onCategorySelected: onCategorySelected,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: context.space.xl)),
      ],
    );
  }
}
