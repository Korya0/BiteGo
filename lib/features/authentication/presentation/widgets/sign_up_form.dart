import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_field.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/validators/email_validator.dart';
import 'package:bite_go/core/validators/latin_only_formatter.dart';
import 'package:bite_go/core/validators/password_validator.dart';
import 'package:bite_go/core/validators/username_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: trigger sign up logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SignUpFields(
            emailController: _emailController,
            passwordController: _passwordController,
            usernameController: _usernameController,
            onUsernameSubmitted: (_) => _submit(),
          ),
          AppGap.h(context.space.md),
          const _TermsText(),
          AppGap.h(context.space.xl),
          _SignUpActions(
            onSignUpPressed: _submit,
            onLoginPressed: () => context.push(AppRoutes.authLogin),
          ),
        ],
      ),
    );
  }
}

// Sign Up Fields

class _SignUpFields extends StatelessWidget {
  const _SignUpFields({
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.onUsernameSubmitted,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final ValueChanged<String> onUsernameSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: AppStrings.signUpEmailLabel,
          hintText: AppStrings.signUpEmailHint,
          controller: emailController,
          autofocus: true,
          showValidationState: true,
          validator: EmailValidator.validate,
          inputFormatters: [latinOnlyFormatter],
        ),
        AppGap.h(context.space.lg),
        AppTextField(
          label: AppStrings.signUpPasswordLabel,
          hintText: AppStrings.signUpPasswordHint,
          controller: passwordController,
          obscureText: true,
          showValidationState: true,
          validator: PasswordValidator.validate,
          inputFormatters: [latinOnlyFormatter],
        ),
        AppGap.h(context.space.lg),
        AppTextField(
          label: AppStrings.signUpUsernameLabel,
          hintText: AppStrings.signUpUsernameHint,
          controller: usernameController,
          showValidationState: true,
          validator: UsernameValidator.validate,
          inputFormatters: [latinOnlyFormatter],
        ),
      ],
    );
  }
}

// Terms Text

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: context.textStyle.caption.copyWith(
          fontSize: context.space.fontSizeXs,
          color: context.color.textSecondary,
        ),
        children: [
          const TextSpan(text: AppStrings.signUpTermsPrefix),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                AppStrings.signUpTermsLink,
                style: context.textStyle.subtitle.copyWith(
                  fontSize: context.space.fontSizeXs,
                  color: context.color.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: context.color.primary,
                ),
              ),
            ),
          ),
          const TextSpan(text: AppStrings.signUpTermsAnd),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                AppStrings.signUpPrivacyLink,
                style: context.textStyle.subtitle.copyWith(
                  fontSize: context.space.fontSizeXs,
                  color: context.color.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: context.color.primary,
                ),
              ),
            ),
          ),
          const TextSpan(text: AppStrings.signUpTermsSuffix),
        ],
      ),
    );
  }
}

// Sign Up Actions

class _SignUpActions extends StatelessWidget {
  const _SignUpActions({
    required this.onSignUpPressed,
    required this.onLoginPressed,
  });

  final VoidCallback onSignUpPressed;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.primary(
          text: AppStrings.signUpButton,
          onPressed: onSignUpPressed,
        ),
      ],
    );
  }
}
