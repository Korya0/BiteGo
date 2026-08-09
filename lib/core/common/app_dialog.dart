import 'package:flutter/material.dart';

class AppDialog {
  const AppDialog._();

  static Future<T?> show<T>(BuildContext context, Widget content) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(content: content),
    );
  }
}
