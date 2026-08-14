import 'dart:async';

import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/logging/error_reporter.dart';

class FakeAppLogger extends AppLogger {
  FakeAppLogger() : super(enableConsole: false, errorReporter: _NoopReporter());

  final List<String> reportedReasons = [];

  @override
  Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool report = false,
    bool fatal = false,
  }) async {
    if (report) {
      reportedReasons.add(message);
    }
  }
}

class _NoopReporter implements ErrorReporter {
  @override
  Future<void> report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object>? metadata,
    bool fatal = false,
  }) async {}

  @override
  void setUserIdentifier(String? identifier) {}
}
