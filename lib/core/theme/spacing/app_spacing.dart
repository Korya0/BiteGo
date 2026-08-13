import 'package:flutter/material.dart';

class AppSpace {
  const AppSpace();

  // Base spacing scale: 4 / 8 / 16 / 24 / 32 / 48.
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 24.0;
  double get xl => 32.0;
  double get xxl => 48.0;

  // Compact steps for small UI details, ordered below or between the base
  // values: xxs(2) < xs(4) < xsSm(6) < sm(8) < smXs(10) < smMd(12) <
  // md(16) < mdLg(20) < lg(24) < xl(32) < xxl(48).
  double get xxs => 2.0;
  double get xsSm => 6.0;
  double get smXs => 10.0;
  double get smMd => 12.0;
  double get mdLg => 20.0;

  EdgeInsets all(double value) => EdgeInsets.all(value);

  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  EdgeInsets only({double left = 0, double top = 0, double right = 0, double bottom = 0}) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
