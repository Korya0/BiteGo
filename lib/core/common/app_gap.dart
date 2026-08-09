import 'package:flutter/material.dart';

class AppGap extends SizedBox {
  const AppGap({super.key, double? h, double? w}) : super(height: h, width: w);
  const AppGap.h(double height, {super.key}) : super(height: height);
  const AppGap.w(double width, {super.key}) : super(width: width);
}
