import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
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
    final allNames = [
      AppStrings.homeCategoryAll,
      ...categories.map((c) => c.name),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.homeFindByCategory,
            style: context.textStyle.title.copyWith(
              fontSize: context.space.fontSizeMd,
              color: context.color.textPrimaryStrong,
              height: 1.5,
            ),
          ),
          AppGap.h(context.space.md),
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allItems.length,
              separatorBuilder: (_, _) => const AppGap.w(12),
              itemBuilder: (context, index) {
                final categoryId = allItems[index];
                final isSelected = selectedCategoryId == categoryId;
                return _CategoryIcon(
                  label: allNames[index],
                  isAll: categoryId == null,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(categoryId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.label,
    required this.isAll,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isAll;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.color.primary
                    : context.color.backgroundPrimary,
                borderRadius: BorderRadius.circular(16.8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 10.5,
                    offset: Offset(0, 2.1),
                  ),
                ],
              ),
              child: Center(
                child: isAll
                    ? Icon(
                        Icons.grid_view_rounded,
                        size: context.space.iconMd,
                        color: isSelected
                            ? context.color.textOnPrimary
                            : context.color.textSecondary,
                      )
                    : Text(
                        label.isEmpty ? '?' : label[0].toUpperCase(),
                        style: context.textStyle.title.copyWith(
                          fontSize: 20,
                          color: isSelected
                              ? context.color.textOnPrimary
                              : context.color.textSecondary,
                        ),
                      ),
              ),
            ),
            const AppGap.h(6),
            Text(
              label,
              key: ValueKey('category_label_$label'),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyle.subtitle.copyWith(
                fontSize: 11,
                color: isSelected
                    ? context.color.primary
                    : context.color.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
