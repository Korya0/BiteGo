import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../error_reporter.dart';

class FirebaseCrashlyticsReporter implements ErrorReporter {
  @override
  Future<void> report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object>? metadata,
    bool fatal = false,
  }) async {
    final List<String> information = [];

    if (metadata != null) {
      for (final entry in metadata.entries) {
        information.add('${entry.key}: ${entry.value}');
      }
    }

    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      information: information,
      fatal: fatal,
    );
  }
}
