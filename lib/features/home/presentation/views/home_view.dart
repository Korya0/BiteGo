import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_snack_bar.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.logoutTitle),
          content: const Text(AppStrings.logoutMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(AppStrings.logoutCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(AppStrings.logoutConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final result = await context.read<AuthSessionCubit>().logout();
    if (result is Error<void> && context.mounted) {
      AppSnackBar.show(context: context, message: result.failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthSessionCubit, UserModel?>((cubit) {
      final state = cubit.state;
      return state is Authenticated ? state.user : null;
    });

    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.homeTitle),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(context.space.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: context.space.xxl,
                  backgroundColor: context.color.primary,
                  child: Text(
                    _initialFor(user),
                    style: context.textStyle.title.copyWith(
                      fontSize: context.space.fontSizeXxl,
                      color: context.color.textOnPrimary,
                    ),
                  ),
                ),
                AppGap.h(context.space.xl),
                Text(
                  user?.username ?? '',
                  textAlign: TextAlign.center,
                  style: context.textStyle.title.copyWith(
                    fontSize: context.space.fontSizeXl,
                    color: context.color.textPrimary,
                  ),
                ),
                AppGap.h(context.space.xs),
                Text(
                  user?.email ?? '',
                  textAlign: TextAlign.center,
                  style: context.textStyle.body.copyWith(
                    fontSize: context.space.fontSizeSm,
                    color: context.color.textSecondary,
                  ),
                ),
                AppGap.h(context.space.xxl),
                AppButton.outlined(
                  text: AppStrings.logoutTitle,
                  onPressed: () => _logout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initialFor(UserModel? user) {
    final username = user?.username ?? '';
    if (username.isEmpty) {
      return '?';
    }
    return username[0].toUpperCase();
  }
}
