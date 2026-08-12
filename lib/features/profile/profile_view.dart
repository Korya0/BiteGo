import 'package:bite_go/core/common/app_snack_bar.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_cubit.dart';
import 'package:bite_go/features/profile/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Profile tab: shows the signed-in user and a logout action.
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<void> _logout() async {
    final result = await context.read<AuthSessionCubit>().logout();
    if (result is Error<void> && mounted) {
      AppSnackBar.show(context: context, message: result.failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileContent(onLogout: _logout);
  }
}
