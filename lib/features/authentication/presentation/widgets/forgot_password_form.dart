import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_field.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/validators/email_validator.dart';
import 'package:bite_go/core/validators/latin_only_formatter.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: trigger send reset email logic
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
          _ForgotPasswordFields(
            emailController: _emailController,
            onEmailSubmitted: (_) => _submit(),
          ),
          AppGap.h(context.space.xl),
          _ForgotPasswordActions(onSendPressed: _submit),
        ],
      ),
    );
  }
}

// Forgot Password Fields

class _ForgotPasswordFields extends StatelessWidget {
  const _ForgotPasswordFields({
    required this.emailController,
    required this.onEmailSubmitted,
  });

  final TextEditingController emailController;
  final ValueChanged<String> onEmailSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: AppStrings.forgotPasswordEmailLabel,
          hintText: AppStrings.forgotPasswordEmailHint,
          controller: emailController,
          autofocus: true,
          showValidationState: true,
          validator: EmailValidator.validate,
          inputFormatters: [latinOnlyFormatter],
        ),
        AppGap.h(context.space.sm),
        Text(
          AppStrings.forgotPasswordHelperText,
          style: context.textStyle.caption.copyWith(
            fontSize: context.space.fontSizeXs,
            color: context.color.textSecondary,
          ),
        ),
      ],
    );
  }
}

// Forgot Password Actions

class _ForgotPasswordActions extends StatelessWidget {
  const _ForgotPasswordActions({required this.onSendPressed});

  final VoidCallback onSendPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      text: AppStrings.forgotPasswordButton,
      onPressed: onSendPressed,
    );
  }
}
