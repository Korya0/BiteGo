import 'package:bite_go/features/home/presentation/cubit/home_cubit.dart';
import 'package:bite_go/features/home/presentation/cubit/home_state.dart';
import 'package:bite_go/features/home/presentation/widgets/home_error_view.dart';
import 'package:bite_go/features/home/presentation/widgets/home_loading_view.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/home_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => const HomeLoadingView(),
          HomeFailure(:final failure) => HomeErrorView(
            message: failure.message,
            onRetry: () => context.read<HomeCubit>().loadHomeData(),
          ),
          HomeSuccess(
            :final banners,
            :final categories,
            :final foods,
            :final selectedCategoryId,
          ) =>
            HomeSuccessView(
              banners: banners,
              categories: categories,
              foods: foods,
              selectedCategoryId: selectedCategoryId,
              onCategorySelected: (categoryId) =>
                  context.read<HomeCubit>().selectCategory(categoryId),
            ),
        };
      },
    );
  }
}
