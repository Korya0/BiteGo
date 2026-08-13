import 'package:bite_go/core/common/app_empty_state.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: context.screenPadding,
              child: AppEmptyState(
                assetPath: AppAssets.svgsEmptyState,
                title: AppStrings.cartEmptyTitle,
                message: AppStrings.cartEmptyMessage,
                actionLabel: AppStrings.cartFindFoods,
                onActionPressed: () => context.go(AppRoutes.search),
              ),
            ),
          ),
        );
      },
    );
  }
}
