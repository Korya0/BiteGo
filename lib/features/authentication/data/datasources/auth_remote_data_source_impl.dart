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
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;

  Future<void>? _googleSignInInit;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseException(
        code: 'null-user',
        message: 'Sign-in succeeded but returned no user.',
        plugin: 'firebase_auth',
      );
    }
    return _loadProfile(user);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
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
      throw FirebaseException(
        code: 'user-profile-not-found',
        message: 'Profile document not found for uid ${user.uid} after sign up.',
        plugin: 'cloud_firestore',
      );
    }
    return UserModel.fromFirestore(
      document.data()!,
      documentId: user.uid,
    );
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _authenticateWithGoogle();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final credentialResult = await _firebaseAuth.signInWithCredential(credential);
    final user = credentialResult.user;
    if (user == null) {
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
    return UserModel.fromFirestore(
      created.data()!,
      documentId: user.uid,
    );
  }

  Future<GoogleSignInAccount> _authenticateWithGoogle() async {
    final init = _googleSignInInit ??= _googleSignIn.initialize();
    try {
      await init;
    } catch (_) {
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
    await _firebaseAuth.sendPasswordResetEmail(email: email);
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
    await _firebaseAuth.signOut();
  }
}
