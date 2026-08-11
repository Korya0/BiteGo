import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bite_go/core/utils/failure.dart';
import 'package:bite_go/core/utils/result.dart';
import 'package:bite_go/features/authentication/data/validators/email_validator.dart';
import 'package:bite_go/features/authentication/data/repositories/auth_repository.dart';
import 'package:bite_go/features/authentication/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordInitial());

  final AuthRepository _authRepository;

  Future<void> sendResetEmail({required String email}) async {
    if (state is ForgotPasswordLoading) {
      return;
    }

    final emailError = EmailValidator.validate(email);
    if (emailError != null) {
      emit(ForgotPasswordFailure(ValidationFailure(emailError)));
      return;
    }

    emit(const ForgotPasswordLoading());

    final result = await _authRepository.sendPasswordResetEmail(email: email);

    if (isClosed) {
      return;
    }

    switch (result) {
      case Success<void>():
        emit(const ForgotPasswordEmailSent());
      case Error<void>():
        emit(ForgotPasswordFailure(result.failure));
    }
  }
}
