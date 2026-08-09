import 'package:flutter/widgets.dart';

enum AppFontWeight {
  regular,
  medium,
  semiBold,
}

extension AppFontWeightX on AppFontWeight {
  FontWeight get value {
    switch (this) {
      case AppFontWeight.regular:
        return FontWeight.w400;
      case AppFontWeight.medium:
        return FontWeight.w500;
      case AppFontWeight.semiBold:
        return FontWeight.w600;
    }
  }
}
