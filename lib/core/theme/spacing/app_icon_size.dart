/// Icon size scale, independent from the spacing scale.
class AppIconSize {
  const AppIconSize();

  // Ordered smallest to largest:
  // xxs(10) < xs(14) < xsSm(16) < smXs(18) < sm(22) < md(24) < lg(32) <
  // xxl(48).
  double get xxs => 10.0;
  double get xs => 14.0;
  double get xsSm => 16.0;
  double get smXs => 18.0;
  double get sm => 22.0;
  double get md => 24.0;
  double get lg => 32.0;
  double get xxl => 48.0;

  double get thumbnail => 80.0;
}