import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_dialog.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_divider.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_state.dart';
import 'package:bite_go/features/authentication/presentation/widgets/auth_header.dart';
import 'package:bite_go/features/authentication/presentation/widgets/google_sign_in_button.dart';
import 'package:bite_go/features/authentication/presentation/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isGoogleLoading = false;

  void _onStateChanged(SignUpState state) {
    if (state is! SignUpLoading && _isGoogleLoading) {
      setState(() => _isGoogleLoading = false);
    }
    if (state is SignUpFailure && state.failure is! CancelledFailure) {
      AppDialog.showInfo(context: context, message: state.failure.message);
    }
  }

  void _signInWithGoogle() {
    if (context.read<SignUpCubit>().state is SignUpLoading) {
      return;
    }
    setState(() => _isGoogleLoading = true);
    context.read<SignUpCubit>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) => _onStateChanged(state),
      child: Scaffold(
        appBar: const AppAppBar(title: AppStrings.signUpAppBarTitle),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: context.space.md,
                right: context.space.md,
                bottom: context.space.xl,
              ),
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
              title: AppStrings.signUpTitle,
              subtitle: AppStrings.signUpSubtitle,
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
        const SignUpForm()
            .animate()
            .fadeIn(delay: 100.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.2,
              end: 0,
              delay: 100.ms,
              duration: 300.ms,
              curve: Curves.easeOutCubic,
            ),
        AppGap.h(context.space.xl),
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
        AppGap.h(context.space.xl),
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
