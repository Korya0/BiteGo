import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_empty_state.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_button.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/food_card.dart';
import 'package:bite_go/features/search/data/models/order_model.dart';
import 'package:bite_go/features/search/presentation/cubit/search_cubit.dart';
import 'package:bite_go/features/search/presentation/cubit/search_state.dart';
import 'package:bite_go/features/search/presentation/widgets/recent_orders_section.dart';
import 'package:bite_go/features/search/presentation/widgets/recent_searches.dart';
import 'package:bite_go/features/search/presentation/widgets/search_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  bool _showCategories = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleCategories() {
    setState(() => _showCategories = !_showCategories);
  }

  void _selectRecentSearch(String term) {
    _searchController.text = term;
    _searchController.selection = TextSelection.collapsed(offset: term.length);
    final cubit = context.read<SearchCubit>();
    cubit.queryChanged(term);
    cubit.submitQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.searchTitle),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: context.screenPadding,
                      child: switch (state) {
                        SearchInitial() || SearchLoading() => _SearchLoadingView(
                          controller: _searchController,
                          showCategories: _showCategories,
                          onFilterPressed: _toggleCategories,
                        ),
                        SearchFailure(:final failure) => _SearchErrorView(
                          message: failure.message,
                          onRetry: () => context.read<SearchCubit>().loadData(),
                        ),
                        SearchSuccess(
                          :final categories,
                          :final query,
                          :final recentSearches,
                        ) =>
                          _SearchSuccessContent(
                            controller: _searchController,
                            categories: categories,
                            query: query,
                            selectedCategoryId: state.selectedCategoryId,
                            foods: state.filteredFoods,
                            recentSearches: recentSearches,
                            showCategories: _showCategories,
                            onFilterPressed: _toggleCategories,
                            onQueryChanged: (value) =>
                                context.read<SearchCubit>().queryChanged(value),
                            onSubmit: () =>
                                context.read<SearchCubit>().submitQuery(),
                            onCategorySelected: (categoryId) => context
                                .read<SearchCubit>()
                                .selectCategory(categoryId),
                            onSearchSelected: _selectRecentSearch,
                            onDeleteSearch: (term) => context
                                .read<SearchCubit>()
                                .deleteRecentSearch(term),
                            onClearAll: () => context
                                .read<SearchCubit>()
                                .clearRecentSearches(),
                          ),
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SearchSuccessContent extends StatelessWidget {
  const _SearchSuccessContent({
    required this.controller,
    required this.categories,
    required this.query,
    required this.selectedCategoryId,
    required this.foods,
    required this.recentSearches,
    required this.showCategories,
    required this.onFilterPressed,
    required this.onQueryChanged,
    required this.onSubmit,
    required this.onCategorySelected,
    required this.onSearchSelected,
    required this.onDeleteSearch,
    required this.onClearAll,
  });

  final TextEditingController controller;
  final List<CategoryModel> categories;
  final String query;
  final String? selectedCategoryId;
  final List<FoodModel> foods;
  final List<String> recentSearches;
  final bool showCategories;
  final VoidCallback onFilterPressed;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onSubmit;
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<String> onSearchSelected;
  final ValueChanged<String> onDeleteSearch;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final searchSection = SearchSection(
      controller: controller,
      categories: categories,
      selectedCategoryId: selectedCategoryId,
      showCategories: showCategories,
      onFilterPressed: onFilterPressed,
      onQueryChanged: onQueryChanged,
      onSubmit: onSubmit,
      onCategorySelected: onCategorySelected,
    );

    final bool showCenteredEmpty = query.trim().isNotEmpty && foods.isEmpty;

    final Widget content = query.trim().isEmpty
        ? _InitialContent(
            recentSearches: recentSearches,
            orders: OrderModel.recentOrders,
            onSearchSelected: onSearchSelected,
            onDeleteSearch: onDeleteSearch,
            onClearAll: onClearAll,
          )
        : showCenteredEmpty
        ? const AppEmptyState(
            assetPath: AppAssets.svgsEmptyState,
            message: AppStrings.searchEmptyResult,
          )
        : _SearchResultsGrid(foods: foods);

    if (showCenteredEmpty) {
      return IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchSection,
            AppGap.h(context.space.md),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchSection,
        AppGap.h(context.space.md),
        content,
      ],
    );
  }
}

class _InitialContent extends StatelessWidget {
  const _InitialContent({
    required this.recentSearches,
    required this.orders,
    required this.onSearchSelected,
    required this.onDeleteSearch,
    required this.onClearAll,
  });

  final List<String> recentSearches;
  final List<OrderModel> orders;
  final ValueChanged<String> onSearchSelected;
  final ValueChanged<String> onDeleteSearch;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recentSearches.isNotEmpty) ...[
          RecentSearches(
            searches: recentSearches,
            onSearchSelected: onSearchSelected,
            onDeleteSearch: onDeleteSearch,
            onClearAll: onClearAll,
          ),
          AppGap.h(context.space.lg),
        ],
        RecentOrdersSection(orders: orders),
      ],
    );
  }
}

class _SearchResultsGrid extends StatelessWidget {
  const _SearchResultsGrid({required this.foods});

  final List<FoodModel> foods;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

class _SearchLoadingView extends StatelessWidget {
  const _SearchLoadingView({
    required this.controller,
    required this.showCategories,
    required this.onFilterPressed,
  });

  final TextEditingController controller;
  final bool showCategories;
  final VoidCallback onFilterPressed;

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
        child: _SearchSuccessContent(
          controller: controller,
          categories: _skeletonCategories,
          query: '',
          selectedCategoryId: null,
          foods: const [],
          recentSearches: const [],
          showCategories: showCategories,
          onFilterPressed: onFilterPressed,
          onQueryChanged: (_) {},
          onSubmit: () {},
          onCategorySelected: (_) {},
          onSearchSelected: (_) {},
          onDeleteSearch: (_) {},
          onClearAll: () {},
        ),
      ),
    );
  }
}

class _SearchErrorView extends StatelessWidget {
  const _SearchErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.space.only(top: context.space.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textStyle.body.copyWith(
              color: context.color.textSecondary,
            ),
          ),
          AppGap.h(context.space.lg),
          AppTextButton(
            text: AppStrings.homeRetry,
            onPressed: onRetry,
            textStyle: context.textStyle.subtitle.copyWith(
              color: context.color.primary,
            ),
          ),
        ],
      ),
    );
  }
}

final List<CategoryModel> _skeletonCategories = [
  CategoryModel(id: 'skeleton-cat-1', name: 'Pizza', sortOrder: 1),
  CategoryModel(id: 'skeleton-cat-2', name: 'Burger', sortOrder: 2),
  CategoryModel(id: 'skeleton-cat-3', name: 'Salad', sortOrder: 3),
  CategoryModel(id: 'skeleton-cat-4', name: 'Drinks', sortOrder: 4),
];