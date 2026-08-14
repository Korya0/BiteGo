import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_dialog.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_button.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:bite_go/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorites_content.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorites_empty_view.dart';
import 'package:bite_go/features/favorites/presentation/widgets/favorites_loading_view.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/food_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBar(
            title: state is FavoritesSuccess && state.isSelectionMode
                ? _selectionTitle(state.selectedIds.length)
                : AppStrings.favoritesTitle,
            actions: _buildActions(context, state),
          ),
          body: SafeArea(
            bottom: false,
            child: switch (state) {
              FavoritesInitial() => const FavoritesLoadingView(),
              FavoritesSuccess() => _FavoritesSuccessContent(state: state),
              FavoritesFailure(:final failure) => _FavoritesErrorView(
                message: failure.message,
                onRetry: () => context.read<FavoritesCubit>().retry(),
              ),
            },
          ),
        );
      },
    );
  }

  String _selectionTitle(int count) {
    return '$count ${AppStrings.favoritesSelectedCount}';
  }

  List<Widget> _buildActions(BuildContext context, FavoritesState state) {
    if (state is! FavoritesSuccess || state.favorites.isEmpty) {
      return const [];
    }
    if (!state.isSelectionMode) {
      return [
        IconButton(
          icon: Icon(
            Icons.checklist_rounded,
            color: context.color.textPrimary,
          ),
          tooltip: AppStrings.favoritesSelect,
          onPressed: () => context.read<FavoritesCubit>().enterSelectionMode(),
        ),
      ];
    }
    return [
      IconButton(
        icon: Icon(
          Icons.delete_outline_rounded,
          color: context.color.textPrimary,
        ),
        tooltip: AppStrings.favoritesDelete,
        onPressed: () => _onDeletePressed(context, state),
      ),
      IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: context.color.textPrimary,
        ),
        tooltip: AppStrings.favoritesCancel,
        onPressed: () => context.read<FavoritesCubit>().exitSelectionMode(),
      ),
    ];
  }

  Future<void> _onDeletePressed(BuildContext context, FavoritesSuccess state) async {
    final count = state.selectedIds.length;
    if (count == 0) {
      return;
    }
    if (count > 1) {
      await AppDialog.showInfo(
        context: context,
        message: AppStrings.favoritesRemoveConfirmMessage,
      );
      if (!context.mounted) {
        return;
      }
    }
    await context.read<FavoritesCubit>().deleteSelected();
  }
}

class _FavoritesSuccessContent extends StatelessWidget {
  const _FavoritesSuccessContent({required this.state});

  final FavoritesSuccess state;

  @override
  Widget build(BuildContext context) {
    if (state.favorites.isEmpty) {
      return const FavoritesEmptyView();
    }
    return SingleChildScrollView(
      child: FavoritesContent(
        favorites: state.favorites,
        isSelectionMode: state.isSelectionMode,
        selectedIds: state.selectedIds,
        onFavoriteTap: (favorite) {
          if (state.isSelectionMode) {
            context.read<FavoritesCubit>().toggleSelection(favorite.id);
          } else {
            showFoodDetailsDialog(context, favorite.food);
          }
        },
      ),
    );
  }
}

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({required this.message, required this.onRetry});

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