import 'package:bite_go/core/constants/app_strings.dart';

class EmailValidator {
  const EmailValidator._();

  static final _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailEmptyError;
    }
    if (!_emailRegExp.hasMatch(value)) {
      return AppStrings.emailInvalidError;
    }
    return null;
  }
}
