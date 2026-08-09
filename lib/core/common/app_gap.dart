import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  const AppGap.vertical(double height, {super.key})
    : _height = height,
      _width = 0;

  const AppGap.horizontal(double width, {super.key})
    : _width = width,
      _height = 0;

  final double _height;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: _height, width: _width);
  }
}
