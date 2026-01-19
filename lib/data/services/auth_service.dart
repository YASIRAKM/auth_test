import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
  Stream<UserModel?> get authStateChanges;
}

class FirebaseAuthService implements AuthService {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<UserModel?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map((fbUser) {
        if (fbUser == null) return null;
        return UserModel(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          name: fbUser.displayName ?? '',
        );
      });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final fb.UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) throw Exception('User not found after login');

      return UserModel(
        id: user.uid,
        email: user.email ?? email,
        name: user.displayName ?? 'No Name',
      );
    } on fb.FirebaseAuthException catch (e) {
      throw Exception('${e.code}: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final fb.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) throw Exception('User not found after registration');

      // Update display name in Firebase Auth
      await user.updateDisplayName(name);

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(id: user.uid, email: user.email ?? email, name: name);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception('${e.code}: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

class DummyAuthService implements AuthService {
  @override
  Stream<UserModel?> get authStateChanges => Stream.value(null);

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'user-not-found@test.com') {
      throw Exception('user-not-found: No user found for that email.');
    } else if (email == 'wrong-password@test.com' || password == 'wrong') {
      throw Exception('wrong-password: Wrong password provided for that user.');
    } else if (email == 'invalid-email@test.com') {
      throw Exception('invalid-email: The email address is badly formatted.');
    }

    return UserModel(id: '1', email: email, name: 'Test User');
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'email-already-in-use@test.com') {
      throw Exception(
        'email-already-in-use: The account already exists for that email.',
      );
    } else if (password.length < 6) {
      throw Exception('weak-password: The password provided is too weak.');
    }

    return UserModel(id: '2', email: email, name: name);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
