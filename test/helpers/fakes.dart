import 'dart:async';

import 'package:bite_go/core/logging/app_logger.dart';
import 'package:bite_go/core/logging/error_reporter.dart';
import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/home/data/datasources/home_remote_data_source.dart';
import 'package:bite_go/features/home/data/models/banner_model.dart';
import 'package:bite_go/features/home/data/models/category_model.dart';
import 'package:bite_go/features/home/data/models/food_model.dart';
import 'package:bite_go/features/home/data/repositories/home_repository.dart';

final UserModel tUser = UserModel(
  uid: 'u1',
  email: 'user@example.com',
  username: 'user1',
  createdAt: DateTime.utc(2024, 1, 1),
);

final BannerModel tBanner = BannerModel(
  id: 'b1',
  imageUrl: 'https://example.com/banner.png',
  sortOrder: 1,
);

final CategoryModel tCategory = CategoryModel(
  id: 'pizza',
  name: 'Pizza',
  sortOrder: 1,
);

final FoodModel tFood = FoodModel(
  id: 'f1',
  name: 'BBQ Chicken Pizza',
  description: 'Grilled chicken, BBQ sauce, red onions, cilantro',
  imageUrl: 'https://example.com/food.png',
  price: 20000,
  rating: 4.6,
  categoryId: 'pizza',
  isAvailable: true,
  sortOrder: 1,
);

class FakeHomeRepository implements HomeRepository {
  Result<List<BannerModel>> bannersResult = const Success(<BannerModel>[]);
  Result<List<CategoryModel>> categoriesResult = const Success(<CategoryModel>[]);
  Result<List<FoodModel>> foodsResult = const Success(<FoodModel>[]);

  int getBannersCalls = 0;
  int getCategoriesCalls = 0;
  int getFoodsCalls = 0;

  @override
  Future<Result<List<BannerModel>>> getBanners() async {
    getBannersCalls++;
    return bannersResult;
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() async {
    getCategoriesCalls++;
    return categoriesResult;
  }

  @override
  Future<Result<List<FoodModel>>> getFoods() async {
    getFoodsCalls++;
    return foodsResult;
  }
}

class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  Object? bannersError;
  Object? categoriesError;
  Object? foodsError;

  List<BannerModel> banners = [tBanner];
  List<CategoryModel> categories = [tCategory];
  List<FoodModel> foods = [tFood];

  @override
  Future<List<BannerModel>> getBanners() async {
    final error = bannersError;
    if (error != null) {
      throw error;
    }
    return banners;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final error = categoriesError;
    if (error != null) {
      throw error;
    }
    return categories;
  }

  @override
  Future<List<FoodModel>> getFoods() async {
    final error = foodsError;
    if (error != null) {
      throw error;
    }
    return foods;
  }
}

class FakeErrorReporter implements ErrorReporter {
  final List<Object> reportedErrors = [];
  String? userIdentifier;
  bool setUserIdentifierCalled = false;

  @override
  Future<void> report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object>? metadata,
    bool fatal = false,
  }) async {
    reportedErrors.add(error);
  }

  @override
  void setUserIdentifier(String? identifier) {
    setUserIdentifierCalled = true;
    userIdentifier = identifier;
  }
}

class FakeAppLogger extends AppLogger {
  FakeAppLogger() : super(enableConsole: false, errorReporter: FakeErrorReporter());

  final List<String> warnings = [];
  final List<String> errors = [];

  @override
  void warning(String message) {
    warnings.add(message);
  }

  @override
  Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool report = false,
    bool fatal = false,
  }) async {
    errors.add(message);
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.loginResult,
    this.signUpResult,
    this.googleSignInResult,
    this.resetPasswordResult,
    this.logoutResult,
    StreamController<Result<UserModel?>>? authStateChangesController,
  }) : authStateChangesController =
           authStateChangesController ?? StreamController<Result<UserModel?>>();

  Result<UserModel>? loginResult;
  Result<UserModel>? signUpResult;
  Result<UserModel>? googleSignInResult;
  Result<void>? resetPasswordResult;
  Result<void>? logoutResult;

  final StreamController<Result<UserModel?>> authStateChangesController;

  Completer<void>? loginGate;
  Completer<void>? signUpGate;
  Completer<void>? googleSignInGate;
  Completer<void>? resetPasswordGate;
  Completer<void>? logoutGate;

  int loginCalls = 0;
  int signUpCalls = 0;
  int googleSignInCalls = 0;
  int resetPasswordCalls = 0;
  int logoutCalls = 0;

  String? lastLoginEmail;
  String? lastLoginPassword;
  String? lastSignUpEmail;
  String? lastSignUpPassword;
  String? lastSignUpUsername;
  String? lastResetEmail;

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    lastLoginEmail = email;
    lastLoginPassword = password;
    if (loginGate != null) {
      await loginGate!.future;
    }
    return loginResult ?? const Error(UnknownFailure());
  }

  @override
  Future<Result<UserModel>> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    signUpCalls++;
    lastSignUpEmail = email;
    lastSignUpPassword = password;
    lastSignUpUsername = username;
    if (signUpGate != null) {
      await signUpGate!.future;
    }
    return signUpResult ?? const Error(UnknownFailure());
  }

  @override
  Future<Result<UserModel>> signInWithGoogle() async {
    googleSignInCalls++;
    if (googleSignInGate != null) {
      await googleSignInGate!.future;
    }
    return googleSignInResult ?? const Error(UnknownFailure());
  }

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async {
    resetPasswordCalls++;
    lastResetEmail = email;
    if (resetPasswordGate != null) {
      await resetPasswordGate!.future;
    }
    return resetPasswordResult ?? const Error(UnknownFailure());
  }

  @override
  Stream<Result<UserModel?>> get authStateChanges =>
      authStateChangesController.stream;

  @override
  Future<Result<void>> logout() async {
    logoutCalls++;
    if (logoutGate != null) {
      await logoutGate!.future;
    }
    return logoutResult ?? const Error(UnknownFailure());
  }
}

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  Object? loginError;
  Object? signUpError;
  Object? googleSignInError;
  Object? resetPasswordError;
  Object? logoutError;

  UserModel? loginUser;
  UserModel? signUpUser;
  UserModel? googleSignInUser;

  int loginCalls = 0;
  int signUpCalls = 0;
  int googleSignInCalls = 0;
  int resetPasswordCalls = 0;
  int logoutCalls = 0;

  String? lastLoginEmail;
  String? lastLoginPassword;
  String? lastSignUpEmail;
  String? lastSignUpPassword;
  String? lastSignUpUsername;
  String? lastResetEmail;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    lastLoginEmail = email;
    lastLoginPassword = password;
    final error = loginError;
    if (error != null) {
      throw error;
    }
    return loginUser ?? tUser;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    signUpCalls++;
    lastSignUpEmail = email;
    lastSignUpPassword = password;
    lastSignUpUsername = username;
    final error = signUpError;
    if (error != null) {
      throw error;
    }
    return signUpUser ?? tUser;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    googleSignInCalls++;
    final error = googleSignInError;
    if (error != null) {
      throw error;
    }
    return googleSignInUser ?? tUser;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    resetPasswordCalls++;
    lastResetEmail = email;
    final error = resetPasswordError;
    if (error != null) {
      throw error;
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(null);

  @override
  Future<void> logout() async {
    logoutCalls++;
    final error = logoutError;
    if (error != null) {
      throw error;
    }
  }
}
