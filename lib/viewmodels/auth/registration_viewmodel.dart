import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di.dart';
import '../../data/models/user_model.dart';

part 'registration_viewmodel.g.dart';

class RegistrationState {
  final AsyncValue<UserModel?> status;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  RegistrationState({
    this.status = const AsyncValue.data(null),
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  RegistrationState copyWith({
    AsyncValue<UserModel?>? status,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }
}

@riverpod
class RegistrationViewModel extends _$RegistrationViewModel {
  @override
  RegistrationState build() {
    return RegistrationState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(status: const AsyncValue.loading());
    try {
      final user = await ref
          .read(authServiceProvider)
          .register(name, email, password);
      state = state.copyWith(status: AsyncValue.data(user));
    } catch (e, st) {
      state = state.copyWith(status: AsyncValue.error(e, st));
    }
  }
}
