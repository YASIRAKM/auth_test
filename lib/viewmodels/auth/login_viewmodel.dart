import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di.dart';
import '../../data/models/user_model.dart';

part 'login_viewmodel.g.dart';

class LoginState {
  final AsyncValue<UserModel?> status;
  final bool obscurePassword;

  LoginState({
    this.status = const AsyncValue.data(null),
    this.obscurePassword = true,
  });

  LoginState copyWith({AsyncValue<UserModel?>? status, bool? obscurePassword}) {
    return LoginState(
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginState build() {
    return LoginState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: const AsyncValue.loading());
    try {
      final user = await ref.read(authServiceProvider).login(email, password);
      state = state.copyWith(status: AsyncValue.data(user));
    } catch (e, st) {
      state = state.copyWith(status: AsyncValue.error(e, st));
    }
  }
}
