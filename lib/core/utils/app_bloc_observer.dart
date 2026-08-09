import 'package:flutter_bloc/flutter_bloc.dart';
import '../logging/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  final AppLogger appLogger;

  AppBlocObserver({required this.appLogger});

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    appLogger.info('Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    appLogger.info('Bloc event: ${bloc.runtimeType} - $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    appLogger.info('Bloc transition: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    appLogger.info('Bloc state changed: ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    appLogger.error(
      'Bloc error in ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
      report: true,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    appLogger.info('Bloc closed: ${bloc.runtimeType}');
  }
}
