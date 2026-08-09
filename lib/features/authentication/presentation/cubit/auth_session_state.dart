import 'package:flutter/foundation.dart';

import 'package:bite_go/features/authentication/data/models/user_model.dart';

@immutable
sealed class AuthSessionState {
  const AuthSessionState();
}

final class AuthSessionUnknown extends AuthSessionState {
  const AuthSessionUnknown();
}

final class Authenticated extends AuthSessionState {
  const Authenticated(this.user);

  final UserModel user;
}

final class Unauthenticated extends AuthSessionState {
  const Unauthenticated();
}
