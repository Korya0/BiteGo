import 'package:bite_go/core/common/app_app_bar.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/authentication/presentation/widgets/auth_header.dart';
import 'package:bite_go/features/authentication/presentation/widgets/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.forgotPasswordAppBarTitle),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: context.space.md,
              right: context.space.md,
              bottom: context.space.xl + context.bottomSystemInset,
            ),
            child: const _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppGap.h(context.space.xl),
        const AuthHeader(title: AppStrings.forgotPasswordTitle)
            .animate()
            .fadeIn(delay: 0.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(begin: 0.2, end: 0, delay: 0.ms, duration: 300.ms, curve: Curves.easeOutCubic),
        AppGap.h(context.space.xl),
        const ForgotPasswordForm()
            .animate()
            .fadeIn(delay: 100.ms, duration: 300.ms, curve: Curves.easeOut)
            .slideY(begin: 0.2, end: 0, delay: 100.ms, duration: 300.ms, curve: Curves.easeOutCubic),
      ],
    );
  }
}
