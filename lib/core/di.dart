import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import '../data/models/user_model.dart';

part 'di.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return FirebaseAuthService();
}

@riverpod
Stream<UserModel?> authState(Ref ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}
