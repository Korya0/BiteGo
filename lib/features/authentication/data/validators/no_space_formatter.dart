import 'package:flutter/services.dart';

final noSpaceFormatter = FilteringTextInputFormatter.deny(
  RegExp(r'\s'),
);
