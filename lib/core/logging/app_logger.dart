import 'dart:async';
import 'package:flutter/foundation.dart';
import 'error_reporter.dart';

class AppLogger {
  final bool enableConsole;
  final ErrorReporter errorReporter;

  AppLogger({
    required this.enableConsole,
    required this.errorReporter,
  });

  void debug(String message) {
    if (enableConsole) {
      debugPrint('[DEBUG] $message');
    }
  }

  void info(String message) {
    if (enableConsole) {
      debugPrint('[INFO] $message');
    }
  }

  void success(String message) {
    if (enableConsole) {
      debugPrint('[SUCCESS] $message');
    }
  }

  void warning(String message) {
    if (enableConsole) {
      debugPrint('[WARNING] $message');
    }
  }

  Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool report = false,
    bool fatal = false,
  }) async {
    if (enableConsole) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('Error: $error');
    }

    if (report) {
      await errorReporter.report(
        error ?? message,
        stackTrace: stackTrace,
        fatal: fatal,
      );
    }
  }
}
