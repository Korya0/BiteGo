/// Google Sign-In / Firebase Auth OAuth configuration.
///
/// Values must match the OAuth clients in `android/app/google-services.json`.
class GoogleAuthConfig {
  const GoogleAuthConfig._();

  /// Web OAuth client ID (`client_type: 3` in google-services.json).
  ///
  /// Required on Android as [GoogleSignIn.initialize]'s `serverClientId` so
  /// Credential Manager can issue an ID token for Firebase Auth.
  static const serverClientId =
      '196173487752-ulpjivoaat6t5532gthle1pdfdufigh9.apps.googleusercontent.com';
}
