import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:bite_go/bite_go_app.dart';
import 'package:bite_go/core/di/app_initializer.dart';
import 'package:bite_go/core/di/app_injector.dart';
import 'package:bite_go/core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.initialize();

  runZonedGuarded(
    () => runApp(const BiteGoApp()),
    (error, stackTrace) {
      getIt<AppLogger>().error(
        'Unhandled error',
        error: error,
        stackTrace: stackTrace,
        report: true,
        fatal: true,
      );
    },
  );
}
