import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bite_go/core/logging/error_reporter.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit({
    required AuthRepository authRepository,
    required ErrorReporter errorReporter,
  })  : _authRepository = authRepository,
        _errorReporter = errorReporter,
        super(const AuthSessionUnknown()) {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  final AuthRepository _authRepository;

  final ErrorReporter _errorReporter;

  late final StreamSubscription<Result<UserModel?>> _authStateSubscription;

  void _onAuthStateChanged(Result<UserModel?> result) {
    switch (result) {
      case Success<UserModel?>(data: final user?):
        _errorReporter.setUserIdentifier(user.uid);
        emit(Authenticated(user));
      case Success<UserModel?>():
        _errorReporter.setUserIdentifier('');
        emit(const Unauthenticated());
      case Error<UserModel?>():
        break;
    }
  }

  Future<Result<void>> logout() {
    return _authRepository.logout();
  }

  @override
  Future<void> close() async {
    await _authStateSubscription.cancel();
    await super.close();
  }
}
