import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/core/validators/email_validator.dart';
import 'package:bite_go/core/validators/password_validator.dart';
import 'package:bite_go/features/authentication/data/models/user_model.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginInitial());

  final AuthRepository _authRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state is LoginLoading) {
      return;
    }

    final emailError = EmailValidator.validate(email);
    if (emailError != null) {
      emit(LoginFailure(ValidationFailure(emailError)));
      return;
    }

    final passwordError = PasswordValidator.validate(password);
    if (passwordError != null) {
      emit(LoginFailure(ValidationFailure(passwordError)));
      return;
    }

    emit(const LoginLoading());

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    if (isClosed) {
      return;
    }

    switch (result) {
      case Success<UserModel>():
        emit(LoginSuccess(result.data));
      case Error<UserModel>():
        emit(LoginFailure(result.failure));
    }
  }
}
