/// Typography size scale, independent from the spacing scale.
class AppFontSize {
  const AppFontSize();

  // Ordered smallest to largest:
  // xxs(11) < xs(12) < xsSm(13) < sm(14) < md(16) < lg(18) < xl(20) <
  // titleSm(22) < xxl(24).
  double get xxs => 11.0;
  double get xs => 12.0;
  double get xsSm => 13.0;
  double get sm => 14.0;
  double get md => 16.0;
  double get lg => 18.0;
  double get xl => 20.0;
  double get titleSm => 22.0;
  double get xxl => 24.0;
}