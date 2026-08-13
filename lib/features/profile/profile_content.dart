import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Temporary profile tab content that shows the signed-in user and a
/// logout action (moved here from the home header).
class ProfileContent extends StatelessWidget {
  const ProfileContent({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthSessionCubit, UserModel?>((cubit) {
      final s = cubit.state;
      return s is Authenticated ? s.user : null;
    });

    final username = user?.username ?? '';
    final email = user?.email ?? '';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: context.space.xxl,
                backgroundColor: context.color.primary,
                child: Text(
                  _initialFor(username),
                  style: context.textStyle.title.copyWith(
                    fontSize: context.fontSize.xxl,
                    color: context.color.textOnPrimary,
                  ),
                ),
              ),
            ),
            AppGap.h(context.space.md),
            Text(
              username.isEmpty ? AppStrings.profileAnonymous : username,
              textAlign: TextAlign.center,
              style: context.textStyle.title.copyWith(
                fontSize: context.fontSize.xl,
                color: context.color.textPrimary,
              ),
            ),
            AppGap.h(context.space.xs),
            Text(
              email.isEmpty
                  ? AppStrings.profileEmailNotAvailable
                  : email,
              textAlign: TextAlign.center,
              style: context.textStyle.body.copyWith(
                fontSize: context.fontSize.sm,
                color: context.color.textSecondary,
              ),
            ),
            const Spacer(),
            AppButton.outlined(
              text: AppStrings.logoutTitle,
              leading: Icon(
                Icons.logout_rounded,
                size: context.iconSize.sm,
              ),
              onPressed: onLogout,
            ),
            AppGap.h(context.space.sm),
          ],
        ),
      ),
    );
  }

  String _initialFor(String username) {
    if (username.isEmpty) {
      return '?';
    }
    return username[0].toUpperCase();
  }
}
