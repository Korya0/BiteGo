import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_field.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/validators/latin_only_formatter.dart';
import 'package:bite_go/features/authentication/data/validators/email_validator.dart';
import 'package:bite_go/features/authentication/data/validators/no_space_formatter.dart';
import 'package:bite_go/features/authentication/data/validators/password_validator.dart';
import 'package:bite_go/features/authentication/data/validators/username_validator.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _formValid = ValueNotifier(false);
  bool _isSignUpLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _formValid.dispose();
    super.dispose();
  }

  void _validateField(String? _) {
    final emailValid = EmailValidator.validate(_emailController.text) == null;
    final passwordValid = PasswordValidator.validate(_passwordController.text) == null;
    final usernameValid = UsernameValidator.validate(_usernameController.text) == null;
    _formValid.value = emailValid && passwordValid && usernameValid;
  }

  void _updateLoading(bool value) {
    if (mounted && _isSignUpLoading != value) {
      setState(() => _isSignUpLoading = value);
    }
  }

  void _submit() {
    if (_isSignUpLoading) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _updateLoading(true);
    context.read<SignUpCubit>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is! SignUpLoading) {
          _updateLoading(false);
        }
      },
      builder: (context, state) {
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
                onEmailChanged: _validateField,
                onPasswordChanged: _validateField,
                onUsernameChanged: _validateField,
              ),
              AppGap.h(context.space.md),
              const _TermsText(),
              AppGap.h(context.space.xl),
              ValueListenableBuilder<bool>(
                valueListenable: _formValid,
                builder: (context, valid, _) {
                  return AppButton.primary(
                    text: AppStrings.signUpButton,
                    onPressed: _submit,
                    isDisabled: !valid,
                    isLoading: _isSignUpLoading,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SignUpFields extends StatelessWidget {
  const _SignUpFields({
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.onUsernameSubmitted,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onUsernameChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final ValueChanged<String> onUsernameSubmitted;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final ValueChanged<String>? onUsernameChanged;

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
          inputFormatters: [latinOnlyFormatter, noSpaceFormatter],
          onChanged: onEmailChanged,
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
          onChanged: onPasswordChanged,
        ),
        AppGap.h(context.space.lg),
        AppTextField(
          label: AppStrings.signUpUsernameLabel,
          hintText: AppStrings.signUpUsernameHint,
          controller: usernameController,
          showValidationState: true,
          validator: UsernameValidator.validate,
          inputFormatters: [latinOnlyFormatter],
          onChanged: onUsernameChanged,
        ),
      ],
    );
  }
}

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
