import 'package:bite_go/core/constants/app_strings.dart';


class PasswordValidator {
  const PasswordValidator._();

  static final _uppercaseRegExp = RegExp(r'[A-Z]');
  static final _lowercaseRegExp = RegExp(r'[a-z]');
  static final _digitRegExp = RegExp(r'[0-9]');
  static final _arabicRegExp = RegExp(r'[\u0600-\u06FF]');

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordEmptyError;
    }
    if (_arabicRegExp.hasMatch(value)) {
      return AppStrings.passwordArabicNotAllowedError;
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShortError;
    }
    if (value.length > 64) {
      return AppStrings.passwordTooLongError;
    }
    if (!_uppercaseRegExp.hasMatch(value)) {
      return AppStrings.passwordMissingUppercaseError;
    }
    if (!_lowercaseRegExp.hasMatch(value)) {
      return AppStrings.passwordMissingLowercaseError;
    }
    if (!_digitRegExp.hasMatch(value)) {
      return AppStrings.passwordMissingNumberError;
    }
    return null;
  }
}
