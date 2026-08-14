import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/authentication/data/repositories/auth_repository.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/presentation/cubit/auth_session_cubit.dart';
import '../../features/authentication/presentation/cubit/forgot_password_cubit.dart';
import '../../features/authentication/presentation/cubit/login_cubit.dart';
import '../../features/authentication/presentation/cubit/sign_up_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/favorites/data/datasources/favorites_remote_data_source.dart';
import '../../features/favorites/data/datasources/favorites_remote_data_source_impl.dart';
import '../../features/favorites/data/repositories/favorites_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/datasources/home_remote_data_source_impl.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../logging/app_logger.dart';
import '../logging/error_reporter.dart';
import '../logging/reporters/firebase_crashlytics_reporter.dart';
import '../services/local_storage.dart';
import '../utils/app_bloc_observer.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firebaseFirestore: getIt<FirebaseFirestore>(),
      googleSignIn: getIt<GoogleSignIn>(),
      appLogger: getIt<AppLogger>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      appLogger: getIt<AppLogger>(),
    ),
  );

  getIt.registerSingleton<ErrorReporter>(FirebaseCrashlyticsReporter());

  getIt.registerLazySingleton<AuthSessionCubit>(
    () => AuthSessionCubit(
      authRepository: getIt<AuthRepository>(),
      errorReporter: getIt<ErrorReporter>(),
    ),
  );
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      homeRemoteDataSource: getIt<HomeRemoteDataSource>(),
      appLogger: getIt<AppLogger>(),
    ),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(homeRepository: getIt<HomeRepository>()),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      homeRepository: getIt<HomeRepository>(),
      localStorage: getIt<LocalStorage>(),
      appLogger: getIt<AppLogger>(),
    ),
  );
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(
      localStorage: getIt<LocalStorage>(),
      appLogger: getIt<AppLogger>(),
    ),
  );
  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      favoritesRemoteDataSource: getIt<FavoritesRemoteDataSource>(),
      appLogger: getIt<AppLogger>(),
    ),
  );
  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      authSessionCubit: getIt<AuthSessionCubit>(),
      favoritesRepository: getIt<FavoritesRepository>(),
    ),
  );
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
