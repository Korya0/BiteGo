import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/food_card.dart';
import 'package:flutter/material.dart';

class HomeContentSection extends StatelessWidget {
  const HomeContentSection({
    required this.categories,
    required this.foods,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    super.key,
  });

  final List<CategoryModel> categories;
  final List<FoodModel> foods;
  final String? selectedCategoryId;
  final void Function(String? categoryId) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilterSection(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: onCategorySelected,
        ),
        _ProductsSection(foods: foods),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textStyle.title.copyWith(
        fontSize: context.space.fontSizeLg,
        color: context.color.textPrimary,
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final void Function(String? categoryId) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final allItems = [null, ...categories.map((c) => c.id)];
    final allNames = [
      AppStrings.homeCategoryAll,
      ...categories.map((c) => c.name),
    ];

    return Padding(
      padding: context.space.only(
        left: context.space.mdLg,
        top: context.space.mdLg,
        right: context.space.mdLg,
        bottom: context.space.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: AppStrings.homeFindByCategory),
          AppGap.h(context.space.md),
          Row(
            children: List.generate(allItems.length, (index) {
              final categoryId = allItems[index];
              final isSelected = selectedCategoryId == categoryId;
              final isLast = index == allItems.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: isLast ? 0 : context.space.xs,
                  ),
                  child: _CategoryChip(
                    label: allNames[index],
                    isSelected: isSelected,
                    onTap: () => onCategorySelected(categoryId),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: context.space.symmetric(
          horizontal: context.space.sm,
          vertical: context.space.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.primary
              : context.color.backgroundPrimary,
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyle.subtitle.copyWith(
            fontSize: context.space.fontSizeSm,
            color: isSelected
                ? context.color.textOnPrimary
                : context.color.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({required this.foods});

  final List<FoodModel> foods;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.space.md),
          child: const _SectionHeader(title: AppStrings.homeSectionPopularFoods),
        ),
        AppGap.h(context.space.sm),
        if (foods.isEmpty)
          const _EmptyFoodsView()
        else
          _FoodsGrid(foods: foods),
      ],
    );
  }
}

class _FoodsGrid extends StatelessWidget {
  const _FoodsGrid({required this.foods});

  final List<FoodModel> foods;

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
      itemBuilder: (context, index) => FoodCard(food: foods[index]),
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
