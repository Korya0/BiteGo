import 'package:bite_go/core/common/app_bottom_nav_bar.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_snack_bar.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/presentation/cubit/home_cubit.dart';
import 'package:bite_go/features/home/presentation/cubit/home_state.dart';
import 'package:bite_go/features/home/presentation/widgets/food_card.dart';
import 'package:bite_go/features/home/presentation/widgets/home_banner_carousel.dart';
import 'package:bite_go/features/home/presentation/widgets/home_category_section.dart';
import 'package:bite_go/features/home/presentation/widgets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BottomNavTab _currentTab = BottomNavTab.home;

  void _onTabSelected(BottomNavTab tab) {
    setState(() => _currentTab = tab);
  }

  Future<void> _logout() async {
    final result = await context.read<AuthSessionCubit>().logout();
    if (result is Error<void> && mounted) {
      AppSnackBar.show(context: context, message: result.failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.scaffoldBackgroundColor,
      body: switch (_currentTab) {
        BottomNavTab.home => const _HomeContent(),
        BottomNavTab.orders => const _StubContent(label: 'Orders'),
        BottomNavTab.cart => const _StubContent(label: 'Cart'),
        BottomNavTab.profile => ProfileContent(onLogout: _logout),
      },
      bottomNavigationBar: AppBottomNavBar(
        currentTab: _currentTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => const _LoadingView(),
          HomeFailure(:final failure) => _ErrorView(
              message: failure.message,
              onRetry: () => context.read<HomeCubit>().loadHomeData(),
            ),
          HomeSuccess() => _SuccessView(state: state),
        };
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.color.primary),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: context.color.error,
            ),
            AppGap.h(context.space.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyle.body.copyWith(
                color: context.color.textSecondary,
              ),
            ),
            AppGap.h(context.space.lg),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.homeRetry,
                style: context.textStyle.subtitle.copyWith(
                  color: context.color.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.state});

  final HomeSuccess state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.banners.isNotEmpty) ...[
                HomeBannerCarousel(banners: state.banners),
                AppGap.h(context.space.md),
              ],
              HomeCategorySection(
                categories: state.categories,
                selectedCategoryId: state.selectedCategoryId,
                onCategorySelected: (id) =>
                    context.read<HomeCubit>().selectCategory(id),
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
        _FoodsGrid(foods: state.filteredFoods),
        SliverToBoxAdapter(child: AppGap.h(context.space.xl)),
      ],
    );
  }
}

class _FoodsGrid extends StatelessWidget {
  const _FoodsGrid({required this.foods});

  final List<FoodModel> foods;

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
                  size: 48,
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
            final food = foods[index];
            return FoodCard(
              food: food,
              onTap: () => context.push(AppRoutes.foodDetails, extra: food),
            );
          },
          childCount: foods.length,
        ),
      ),
    );
  }
}

class _StubContent extends StatelessWidget {
  const _StubContent({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          label,
          style: context.textStyle.title.copyWith(
            fontSize: context.space.fontSizeXl,
            color: context.color.textSecondary,
          ),
        ),
      ),
    );
  }
}
