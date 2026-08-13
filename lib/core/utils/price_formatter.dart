String formatPrice(double price, {bool withUnit = false}) {
  final p = price.toInt();
  final value = p >= 1000
      ? '${(p / 1000).toStringAsFixed(p % 1000 == 0 ? 0 : 1)}k'
      : '$p';
  return withUnit ? '$value IQD' : value;
}
