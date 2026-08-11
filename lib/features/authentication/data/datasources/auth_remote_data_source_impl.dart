import 'package:bite_go/core/constants/google_auth_config.dart';
import 'package:bite_go/core/logging/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    GoogleSignIn? googleSignIn,
    String? googleServerClientId,
    required AppLogger appLogger,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _googleServerClientId =
            googleServerClientId ?? GoogleAuthConfig.serverClientId,
        _appLogger = appLogger;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;
  final String _googleServerClientId;
  final AppLogger _appLogger;

  Future<void>? _googleSignInInit;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    _appLogger.info('Auth: email/password login started');
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      _appLogger.error('Auth: login succeeded but Firebase returned no user');
      throw FirebaseException(
        code: 'null-user',
        message: 'Sign-in succeeded but returned no user.',
        plugin: 'firebase_auth',
      );
    }
    final profile = await _loadProfile(user);
    _appLogger.success('Auth: email/password login succeeded');
    return profile;
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    _appLogger.info('Auth: sign up started');
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      _appLogger.error(
        'Auth: account creation succeeded but Firebase returned no user',
      );
      throw FirebaseException(
        code: 'null-user',
        message: 'Account creation succeeded but returned no user.',
        plugin: 'firebase_auth',
      );
    }
    final profile = UserModel(
      uid: user.uid,
      email: user.email ?? email,
      username: username,
      createdAt: DateTime.now(),
    );
    await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(profile.toFirestoreMap());
    final document = await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .get();
    if (!document.exists) {
      _appLogger.error(
        'Auth: profile document missing after sign up (uid: ${user.uid})',
      );
      throw FirebaseException(
        code: 'user-profile-not-found',
        message: 'Profile document not found for uid ${user.uid} after sign up.',
        plugin: 'cloud_firestore',
      );
    }
    _appLogger.success('Auth: sign up succeeded');
    return UserModel.fromFirestore(
      document.data()!,
      documentId: user.uid,
    );
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    _appLogger.info('Auth: Google sign-in started');
    final googleUser = await _authenticateWithGoogle();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final credentialResult = await _firebaseAuth.signInWithCredential(credential);
    final user = credentialResult.user;
    if (user == null) {
      _appLogger.error(
        'Auth: Google sign-in succeeded but Firebase returned no user',
      );
      throw FirebaseException(
        code: 'null-user',
        message: 'Google sign-in succeeded but returned no user.',
        plugin: 'firebase_auth',
      );
    }
    final document = await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .get();
    if (document.exists) {
      _appLogger.success('Auth: Google sign-in succeeded');
      return UserModel.fromFirestore(
        document.data()!,
        documentId: user.uid,
      );
    }
    final email = user.email ?? googleUser.email;
    final profile = UserModel(
      uid: user.uid,
      email: email,
      username: user.displayName ?? googleUser.displayName ?? email.split('@').first,
      photoUrl: user.photoURL ?? googleUser.photoUrl,
      createdAt: DateTime.now(),
    );
    await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(profile.toFirestoreMap());
    final created = await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .get();
    _appLogger.success('Auth: Google sign-in succeeded');
    return UserModel.fromFirestore(
      created.data()!,
      documentId: user.uid,
    );
  }

  Future<GoogleSignInAccount> _authenticateWithGoogle() async {
    final init = _googleSignInInit ??= _googleSignIn.initialize(
      // Android Credential Manager requires the Web OAuth client ID.
      serverClientId: _googleServerClientId,
    );
    try {
      await init;
    } catch (error, stackTrace) {
      _appLogger.error(
        'Auth: GoogleSignIn initialization failed; will retry next call',
        error: error,
        stackTrace: stackTrace,
      );
      _googleSignInInit = null;
      rethrow;
    }
    try {
      return await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      throw FirebaseException(
        code: e.code.name,
        message: e.description,
        plugin: 'google_sign_in',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    _appLogger.info('Auth: password reset email requested');
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    _appLogger.success('Auth: password reset email sent');
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      return _loadProfile(firebaseUser);
    });
  }

  Future<UserModel> _loadProfile(User firebaseUser) async {
    final document = await _firebaseFirestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();
    if (!document.exists) {
      _appLogger.error(
        'Auth: no profile document found for uid ${firebaseUser.uid}',
      );
      throw FirebaseException(
        code: 'user-profile-not-found',
        message: 'No profile document found for uid ${firebaseUser.uid}.',
        plugin: 'cloud_firestore',
      );
    }
    return UserModel.fromFirestore(
      document.data()!,
      documentId: firebaseUser.uid,
    );
  }

  @override
  Future<void> logout() async {
    _appLogger.info('Auth: logout started');
    await _firebaseAuth.signOut();
    _appLogger.success('Auth: logout completed');
  }
}
