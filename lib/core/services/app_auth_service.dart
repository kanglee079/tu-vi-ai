import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthSession {
  const AuthSession({
    required this.uid,
    required this.isAnonymous,
    this.email,
    this.displayName,
  });

  final String uid;
  final bool isAnonymous;
  final String? email;
  final String? displayName;
}

abstract class AppAuthService {
  Stream<AuthSession?> authStateChanges();
  AuthSession? currentSession();
  Future<void> ensureGuestSession();
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });
  Future<AuthSession> registerWithEmail({
    required String email,
    required String password,
  });
  Future<AuthSession> signInWithGoogle();
  Future<AuthSession> signInWithApple();
  Future<void> signOut();
  Future<String?> currentIdToken({bool forceRefresh = false});
}

class PrototypeAuthService implements AppAuthService {
  AuthSession? _current = const AuthSession(
    uid: 'prototype_guest_uid',
    isAnonymous: true,
    displayName: 'Khách',
  );

  @override
  Stream<AuthSession?> authStateChanges() async* {
    yield _current;
  }

  @override
  AuthSession? currentSession() => _current;

  @override
  Future<String?> currentIdToken({bool forceRefresh = false}) async {
    return 'prototype-token';
  }

  @override
  Future<void> ensureGuestSession() async {}

  @override
  Future<AuthSession> registerWithEmail({
    required String email,
    required String password,
  }) async {
    _current = AuthSession(
      uid: 'prototype_registered_uid',
      isAnonymous: false,
      email: email,
      displayName: email.split('@').first,
    );
    return _current!;
  }

  @override
  Future<AuthSession> signInWithApple() async {
    _current = const AuthSession(
      uid: 'prototype_apple_uid',
      isAnonymous: false,
      displayName: 'Apple User',
    );
    return _current!;
  }

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _current = AuthSession(
      uid: 'prototype_email_uid',
      isAnonymous: false,
      email: email,
      displayName: email.split('@').first,
    );
    return _current!;
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    _current = const AuthSession(
      uid: 'prototype_google_uid',
      isAnonymous: false,
      displayName: 'Google User',
    );
    return _current!;
  }

  @override
  Future<void> signOut() async {
    _current = const AuthSession(
      uid: 'prototype_guest_uid',
      isAnonymous: true,
      displayName: 'Khách',
    );
  }
}

class FirebaseAppAuthService implements AppAuthService {
  FirebaseAppAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _googleInitialized = false;

  @override
  Stream<AuthSession?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  AuthSession? currentSession() => _mapUser(_firebaseAuth.currentUser);

  @override
  Future<String?> currentIdToken({bool forceRefresh = false}) async {
    return _firebaseAuth.currentUser?.getIdToken(forceRefresh);
  }

  @override
  Future<void> ensureGuestSession() async {
    if (_firebaseAuth.currentUser != null) {
      return;
    }
    await _firebaseAuth.signInAnonymously();
  }

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    UserCredential result;
    if (user != null && user.isAnonymous) {
      result = await user.linkWithCredential(credential);
    } else {
      result = await _firebaseAuth.signInWithCredential(credential);
    }
    return _mapUser(result.user)!;
  }

  @override
  Future<AuthSession> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user != null && user.isAnonymous) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      final linked = await user.linkWithCredential(credential);
      return _mapUser(linked.user)!;
    }
    final created = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(created.user)!;
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    await _ensureGoogleInitialized();
    final googleAccount = await _googleSignIn.authenticate();
    final idToken = googleAccount.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'google-id-token-missing',
        message: 'Google Sign-In không trả về ID token hợp lệ.',
      );
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final result = await _linkOrSignInWithCredential(credential);
    return _mapUser(result.user)!;
  }

  @override
  Future<AuthSession> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = _sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);
    final result = await _linkOrSignInWithCredential(oauthCredential);
    return _mapUser(result.user)!;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await ensureGuestSession();
  }

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) {
      return;
    }
    await _googleSignIn.initialize();
    _googleInitialized = true;
  }

  Future<UserCredential> _linkOrSignInWithCredential(
    AuthCredential credential,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user != null && user.isAnonymous) {
      return user.linkWithCredential(credential);
    }
    return _firebaseAuth.signInWithCredential(credential);
  }

  AuthSession? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthSession(
      uid: user.uid,
      isAnonymous: user.isAnonymous,
      email: user.email,
      displayName: user.displayName,
    );
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List<String>.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
