import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../logging/app_logger.dart';
import '../logging/error_reporter.dart';
import '../logging/reporters/firebase_crashlytics_reporter.dart';
import '../services/local_storage.dart';
import '../utils/app_bloc_observer.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<ErrorReporter>(FirebaseCrashlyticsReporter());
  getIt.registerSingleton<AppLogger>(
    AppLogger(
      enableConsole: kDebugMode,
      errorReporter: getIt<ErrorReporter>(),
    ),
  );
  getIt.registerSingleton<AppBlocObserver>(
    AppBlocObserver(appLogger: getIt<AppLogger>()),
  );
  getIt.registerLazySingleton<LocalStorage>(HiveLocalStorage.new);
}
