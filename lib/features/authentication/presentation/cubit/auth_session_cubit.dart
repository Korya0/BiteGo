import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/presentation/cubit/auth_session_state.dart';

class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthSessionUnknown()) {
    _authStateSubscription = _authRepository.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  final AuthRepository _authRepository;

  late final StreamSubscription<Result<UserModel?>> _authStateSubscription;

  void _onAuthStateChanged(Result<UserModel?> result) {
    switch (result) {
      case Success<UserModel?>(data: final user?):
        emit(Authenticated(user));
      case Success<UserModel?>():
        emit(const Unauthenticated());
      case Error<UserModel?>():
        break;
    }
  }

  @override
  Future<void> close() async {
    await _authStateSubscription.cancel();
    await super.close();
  }
}
