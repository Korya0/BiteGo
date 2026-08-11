import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/features/authentication/data/validators/email_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailValidator.validate', () {
    test('returns empty error for null', () {
      expect(EmailValidator.validate(null), AppStrings.emailEmptyError);
    });

    test('returns empty error for empty string', () {
      expect(EmailValidator.validate(''), AppStrings.emailEmptyError);
    });

    test('returns invalid error for malformed input', () {
      expect(EmailValidator.validate('not-an-email'), AppStrings.emailInvalidError);
      expect(EmailValidator.validate('user@'), AppStrings.emailInvalidError);
      expect(EmailValidator.validate('user@example'), AppStrings.emailInvalidError);
      expect(EmailValidator.validate('@example.com'), AppStrings.emailInvalidError);
      expect(EmailValidator.validate('user@.com'), AppStrings.emailInvalidError);
    });

    test('returns null for valid email', () {
      expect(EmailValidator.validate('user@example.com'), isNull);
      expect(EmailValidator.validate('user.name+tag@sub.example.co'), isNull);
      expect(EmailValidator.validate('USER@EXAMPLE.COM'), isNull);
      expect(EmailValidator.validate('a@b.io'), isNull);
    });
  });
}
