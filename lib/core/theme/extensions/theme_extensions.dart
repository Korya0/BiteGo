import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../fonts/app_font_size.dart';
import '../fonts/app_text_styles.dart';
import '../spacing/app_icon_size.dart';
import '../spacing/app_spacing.dart';
import '../spacing/app_radius.dart';
import '../spacing/app_shadow.dart';
import '../spacing/app_opacity.dart';

extension ColorExtension on BuildContext {
  AppColors get color => const AppColors();
}

extension TextStyleExtension on BuildContext {
  AppTextStyles get textStyle => const AppTextStyles();
}

extension FontSizeExtension on BuildContext {
  AppFontSize get fontSize => const AppFontSize();
}

extension IconSizeExtension on BuildContext {
  AppIconSize get iconSize => const AppIconSize();
}

extension SpaceExtension on BuildContext {
  AppSpace get space => const AppSpace();

  EdgeInsets get screenPadding => EdgeInsets.only(
    left: space.md,
    right: space.md,
    bottom: space.xl + bottomSystemInset,
  );
}

extension RadiusExtension on BuildContext {
  AppRadius get radius => const AppRadius();
}

extension ShadowExtension on BuildContext {
  AppShadow get shadow => const AppShadow();
}

extension OpacityExtension on BuildContext {
  AppOpacity get opacity => const AppOpacity();
}

extension SystemInsetsExtension on BuildContext {
  /// System UI padding (status bar, navigation bar, notches).
  EdgeInsets get systemInsets => MediaQuery.paddingOf(this);

  double get bottomSystemInset => systemInsets.bottom;
}
