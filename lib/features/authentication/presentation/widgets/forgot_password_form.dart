import 'package:bite_go/core/common/app_button.dart';
import 'package:bite_go/core/common/app_dialog.dart';
import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/app_text_field.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/routes/app_routes.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/validators/latin_only_formatter.dart';
import 'package:bite_go/features/authentication/data/validators/email_validator.dart';
import 'package:bite_go/features/authentication/data/validators/no_space_formatter.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_cubit.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _formValid = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _formValid.dispose();
    super.dispose();
  }

  void _validateField(String? _) {
    _formValid.value = EmailValidator.validate(_emailController.text) == null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<ForgotPasswordCubit>().sendResetEmail(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) async {
        if (state is ForgotPasswordEmailSent) {
          await AppDialog.showInfo(
            context: context,
            message: AppStrings.forgotPasswordEmailSent,
          );
          if (!context.mounted) {
            return;
          }
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.authLogin);
          }
        } else if (state is ForgotPasswordFailure) {
          AppDialog.showInfo(context: context, message: state.failure.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ForgotPasswordFields(
                emailController: _emailController,
                onEmailSubmitted: (_) => _submit(),
                onEmailChanged: _validateField,
              ),
              AppGap.h(context.space.xl),
              ValueListenableBuilder<bool>(
                valueListenable: _formValid,
                builder: (context, valid, _) {
                  return AppButton.primary(
                    text: AppStrings.forgotPasswordButton,
                    onPressed: isLoading ? null : _submit,
                    isDisabled: !valid,
                    isLoading: isLoading,
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

class _ForgotPasswordFields extends StatelessWidget {
  const _ForgotPasswordFields({
    required this.emailController,
    required this.onEmailSubmitted,
    required this.onEmailChanged,
  });

  final TextEditingController emailController;
  final ValueChanged<String> onEmailSubmitted;
  final ValueChanged<String>? onEmailChanged;

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
          inputFormatters: [latinOnlyFormatter, noSpaceFormatter],
          onChanged: onEmailChanged,
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
