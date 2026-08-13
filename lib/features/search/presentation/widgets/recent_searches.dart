import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_button.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/search/presentation/widgets/search_section_header.dart';
import 'package:flutter/material.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({
    required this.searches,
    required this.onSearchSelected,
    required this.onDeleteSearch,
    required this.onClearAll,
    super.key,
  });

  final List<String> searches;
  final ValueChanged<String> onSearchSelected;
  final ValueChanged<String> onDeleteSearch;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: SearchSectionHeader(title: AppStrings.searchRecentSearches),
            ),
            AppTextButton(
              text: AppStrings.searchDelete,
              onPressed: onClearAll,
              textStyle: context.textStyle.subtitle.copyWith(
                fontSize: context.fontSize.xsSm,
                color: context.color.primary,
              ),
            ),
          ],
        ),
        AppGap.h(context.space.sm),
        for (var index = 0; index < searches.length; index++) ...[
          if (index > 0)
            Divider(
              height: 1,
              thickness: 0.7,
              color: context.color.textSecondary,
            ),
          _RecentSearchRow(
            term: searches[index],
            onTap: () => onSearchSelected(searches[index]),
            onDelete: () => onDeleteSearch(searches[index]),
          ),
        ],
      ],
    );
  }
}

class _RecentSearchRow extends StatelessWidget {
  const _RecentSearchRow({
    required this.term,
    required this.onTap,
    required this.onDelete,
  });

  final String term;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.history_rounded,
          size: context.iconSize.xsSm,
          color: context.color.textSecondary,
        ),
        AppGap.w(context.space.smMd),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: context.space.symmetric(vertical: context.space.smMd),
              child: Text(
                term,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.body.copyWith(
                  fontSize: context.fontSize.sm,
                  color: context.color.textPrimary,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onDelete,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: context.space.all(context.space.xs),
            child: Icon(
              Icons.close_rounded,
              size: context.iconSize.xs,
              color: context.color.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}