import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({
    required this.controller,
    required this.categories,
    required this.selectedCategoryId,
    required this.showCategories,
    required this.onFilterPressed,
    required this.onQueryChanged,
    required this.onSubmit,
    required this.onCategorySelected,
    super.key,
  });

  final TextEditingController controller;
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final bool showCategories;
  final VoidCallback onFilterPressed;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSubmit;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppGap.h(context.space.md),
        _SearchTextField(
          controller: controller,
          showCategories: showCategories,
          onFilterPressed: onFilterPressed,
          onChanged: onQueryChanged,
          onSubmit: onSubmit,
        ),
        if (showCategories) ...[
          AppGap.h(context.space.smMd),
          _SearchCategoryFilter(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            onCategorySelected: onCategorySelected,
          ),
        ],
      ],
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.controller,
    required this.showCategories,
    required this.onFilterPressed,
    required this.onChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool showCategories;
  final VoidCallback onFilterPressed;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.space.xxl,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.backgroundPrimary,
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
        child: Row(
          children: [
            AppGap.w(context.space.smMd),
            Icon(
              Icons.search_rounded,
              size: context.iconSize.xsSm,
              color: context.color.textSecondary,
            ),
            AppGap.w(context.space.xs),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                onChanged: onChanged,
                onSubmitted: (_) => onSubmit(),
                textInputAction: TextInputAction.search,
                style: context.textStyle.body.copyWith(
                  fontSize: context.fontSize.sm,
                  color: context.color.textPrimaryStrong,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: AppStrings.searchHint,
                  hintStyle: context.textStyle.body.copyWith(
                    fontSize: context.fontSize.sm,
                    color: context.color.textPrimaryStrong.withValues(
                      alpha: context.opacity.disabled,
                    ),
                  ),
                ),
              ),
            ),
            AppGap.w(context.space.sm),
            GestureDetector(
              onTap: onFilterPressed,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: context.space.xl,
                height: context.space.xl,
                decoration: BoxDecoration(
                  color: showCategories
                      ? context.color.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(context.radius.md),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: context.iconSize.smXs,
                  color: showCategories
                      ? context.color.textOnPrimary
                      : context.color.primary,
                ),
              ),
            ),
            AppGap.w(context.space.xs),
          ],
        ),
      ),
    );
  }
}

class _SearchCategoryFilter extends StatelessWidget {
  const _SearchCategoryFilter({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final allItems = [null, ...categories.map((category) => category.id)];
    final allNames = [
      AppStrings.homeCategoryAll,
      ...categories.map((category) => category.name),
    ];

    return Row(
      children: List.generate(allItems.length, (index) {
        final categoryId = allItems[index];
        final isLast = index == allItems.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: isLast ? 0 : context.space.xs,
            ),
            child: _SearchCategoryTile(
              label: allNames[index],
              isSelected: selectedCategoryId == categoryId,
              onTap: () => onCategorySelected(categoryId),
            ),
          ),
        );
      }),
    );
  }
}

class _SearchCategoryTile extends StatelessWidget {
  const _SearchCategoryTile({
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
            fontSize: context.fontSize.sm,
            color: isSelected
                ? context.color.textOnPrimary
                : context.color.textSecondary,
          ),
        ),
      ),
    );
  }
}