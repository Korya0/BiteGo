import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logging/app_logger.dart';
import '../utils/app_bloc_observer.dart';
import 'app_injector.dart';

class AppInitializer {
  static Future<void> initialize() async {

    await Firebase.initializeApp();

    await setupDependencies();

    Bloc.observer = getIt<AppBlocObserver>();

    _setupGlobalErrorHandlers();
  }

  static void _setupGlobalErrorHandlers() {
    final logger = getIt<AppLogger>();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logger.error(
        'Flutter framework error',
        error: details.exception,
        stackTrace: details.stack,
        report: true,
      );
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      logger.error(
        'Platform error',
        error: error,
        stackTrace: stackTrace,
        report: true,
      );
      return true;
    };
  }
}
