import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../error_reporter.dart';

// TODO: 2) Set user identifier on login/logout via FirebaseCrashlytics.instance.setUserIdentifier(userId).
// TODO: 3) Add breadcrumb logs via FirebaseAnalytics.instance.logEvent() in key screens/buttons.
// TODO: 4) Upload symbols after obfuscated builds:
//          firebase crashlytics:symbols:upload --app=FIREBASE_APP_ID PATH/TO/symbols
// [x] 5) Test in release mode with FirebaseCrashlytics.instance.crash() and verify in Firebase Console.

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
