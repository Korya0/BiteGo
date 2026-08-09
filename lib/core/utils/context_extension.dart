import 'package:flutter/material.dart';
export '../theme/extensions/theme_extensions.dart';

extension IsDarkModeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension L10nExtension on BuildContext {
  AppL10n get l10n => const AppL10n();
}

class AppL10n {
  const AppL10n();

  String get ok => 'OK';
}
