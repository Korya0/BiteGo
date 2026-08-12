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
          SliverToBoxAdapter(child: HomeBannerSection(banners: banners)),
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
