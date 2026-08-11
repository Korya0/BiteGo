import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/validators/email_validator.dart';
import 'package:bite_go/features/authentication/data/validators/password_validator.dart';
import 'package:bite_go/features/authentication/data/validators/username_validator.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/presentation/cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignUpInitial());

  final AuthRepository _authRepository;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    if (state is SignUpLoading) {
      return;
    }

    final emailError = EmailValidator.validate(email);
    if (emailError != null) {
      emit(SignUpFailure(ValidationFailure(emailError)));
      return;
    }

    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      emit(SignUpFailure(ValidationFailure(passwordError)));
      return;
    }

    final usernameError = UsernameValidator.validate(username);
    if (usernameError != null) {
      emit(SignUpFailure(ValidationFailure(usernameError)));
      return;
    }

    emit(const SignUpLoading());

    final result = await _authRepository.signUp(
      email: email,
      password: password,
      username: username,
    );

    _handleResult(result);
  }

  Future<void> signInWithGoogle() async {
    if (state is SignUpLoading) {
      return;
    }

    emit(const SignUpLoading());

    final result = await _authRepository.signInWithGoogle();

    _handleResult(result);
  }

  void _handleResult(Result<UserModel> result) {
    if (isClosed) {
      return;
    }
    switch (result) {
      case Success<UserModel>():
        emit(SignUpSuccess(result.data));
      case Error<UserModel>():
        emit(SignUpFailure(result.failure));
    }
  }
}
