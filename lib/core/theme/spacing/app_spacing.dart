import 'package:flutter/material.dart';

class AppSpace {
  const AppSpace();

  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 24.0;
  double get xl => 32.0;
  double get xxl => 48.0;

  double get fontSizeXs => 12.0;
  double get fontSizeSm => 14.0;
  double get fontSizeMd => 16.0;
  double get fontSizeLg => 18.0;
  double get fontSizeXl => 20.0;
  double get fontSizeTitleSm => 22.0;
  double get fontSizeXxl => 24.0;

  double get iconXs => 14.0;
  double get iconSm => 22.0;
  double get iconMd => 24.0;
  double get iconLg => 32.0;

  EdgeInsets all(double value) => EdgeInsets.all(value);

  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  EdgeInsets only({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
