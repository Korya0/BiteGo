import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_button.dart';
import 'package:bite_go/core/common/app_text_field.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/validators/email_validator.dart';
import 'package:bite_go/core/validators/latin_only_formatter.dart';
import 'package:bite_go/core/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: trigger login logic
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
          _LoginFields(
            emailController: _emailController,
            passwordController: _passwordController,
            passwordFocusNode: _passwordFocusNode,
            onPasswordSubmitted: (_) => _submit(),
          ),
          AppGap.h(context.space.xl),
          _LoginActions(
            onLoginPressed: _submit,
            onSignUpPressed: () => context.push(AppRoutes.authSignUp),
          ),
        ],
      ),
    );
  }
}

// Login Fields

class _LoginFields extends StatelessWidget {
  const _LoginFields({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onPasswordSubmitted,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final ValueChanged<String> onPasswordSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: AppStrings.loginEmailLabel,
          hintText: AppStrings.loginEmailHint,
          controller: emailController,
          autofocus: true,
          showValidationState: true,
          validator: EmailValidator.validate,
          inputFormatters: [latinOnlyFormatter],
        ),
        AppGap.h(context.space.lg),
        AppTextField(
          label: AppStrings.loginPasswordLabel,
          hintText: AppStrings.loginPasswordHint,
          controller: passwordController,
          obscureText: true,
          showValidationState: true,
          validator: PasswordValidator.validate,
          inputFormatters: [latinOnlyFormatter],
        ),
        AppGap.h(context.space.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: AppTextButton(
            text: AppStrings.loginForgotPassword,
            onPressed: () => context.push(AppRoutes.authForgotPassword),
            textStyle: context.textStyle.subtitle.copyWith(
              fontSize: context.space.fontSizeSm,
              color: context.color.primary,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: context.space.xs,
              vertical: context.space.xs,
            ),
          ),
        ),
      ],
    );
  }
}

// Login Actions

class _LoginActions extends StatelessWidget {
  const _LoginActions({
    required this.onLoginPressed,
    required this.onSignUpPressed,
  });

  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.primary(
          text: AppStrings.loginButton,
          onPressed: onLoginPressed,
        ),
      ],
    );
  }
}
