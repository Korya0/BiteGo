import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    super.key,
  });

  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final void Function(String? categoryId) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final allItems = [null, ...categories.map((c) => c.id)];
    final allNames = ['All', ...categories.map((c) => c.name)];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.space.md),
        itemCount: allItems.length,
        separatorBuilder: (_, _) => SizedBox(width: context.space.sm),
        itemBuilder: (context, index) {
          final categoryId = allItems[index];
          final isSelected = selectedCategoryId == categoryId;
          return _CategoryChip(
            label: allNames[index],
            isSelected: isSelected,
            onTap: () => onCategorySelected(categoryId),
          );
        },
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.space.md,
          vertical: context.space.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.color.primary : context.color.backgroundSecondary,
          borderRadius: BorderRadius.circular(context.radius.xxl),
        ),
        child: Text(
          label,
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
