import 'package:flutter/material.dart';

export '../theme/extensions/theme_extensions.dart';

extension FocusExtension on BuildContext {
  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}
