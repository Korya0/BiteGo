import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_divider.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_state.dart';
import 'package:bite_go/features/authentication/presentation/widgets/auth_error_text.dart';
import 'package:bite_go/features/authentication/presentation/widgets/auth_header.dart';
import 'package:bite_go/features/authentication/presentation/widgets/google_sign_in_button.dart';
import 'package:bite_go/features/authentication/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isGoogleLoading = false;

  void _onStateChanged(LoginState state) {
    if (state is! LoginLoading && _isGoogleLoading) {
      setState(() => _isGoogleLoading = false);
    }
  }

  void _signInWithGoogle() {
    if (context.read<LoginCubit>().state is LoginLoading) {
      return;
    }
    setState(() => _isGoogleLoading = true);
    context.read<LoginCubit>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) => _onStateChanged(state),
      child: Scaffold(
        appBar: const AppAppBar(title: AppStrings.loginAppBarTitle),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: context.screenPadding,
              child: _Body(
                isGoogleLoading: _isGoogleLoading,
                onGooglePressed: _signInWithGoogle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.isGoogleLoading,
    required this.onGooglePressed,
  });

  final bool isGoogleLoading;
  final VoidCallback onGooglePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppGap.h(context.space.xl),
        const AuthHeader(
              title: AppStrings.loginTitle,
              subtitle: AppStrings.loginSubtitle,
            )
            .animate()
            .fadeIn(delay: 0.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.2,
              end: 0,
              delay: 0.ms,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),
        AppGap.h(context.space.xl),
        const LoginForm()
            .animate()
            .fadeIn(delay: 100.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.2,
              end: 0,
              delay: 100.ms,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType ||
              (previous is LoginFailure &&
                  current is LoginFailure &&
                  previous.failure.message != current.failure.message),
          builder: (context, state) {
            final message =
                state is LoginFailure && state.failure is! CancelledFailure
                ? state.failure.message
                : null;
            return AuthErrorText(message: message);
          },
        ),

        const AppTextDivider(text: AppStrings.or)
            .animate()
            .fadeIn(delay: 200.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.2,
              end: 0,
              delay: 200.ms,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),
        GoogleSignInButton(
              onPressed: onGooglePressed,
              isLoading: isGoogleLoading,
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.2,
              end: 0,
              delay: 200.ms,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }
}
