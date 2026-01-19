extension ValidationExt on String? {
  String? validateEmail() {
    if (this == null || this!.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(this!)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword() {
    if (this == null || this!.isEmpty) {
      return 'Password is required';
    }
    if (this!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName() {
    if (this == null || this!.isEmpty) {
      return 'Name is required';
    }
    if (this!.length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  String? validateConfirmPassword(String? password) {
    if (this == null || this!.isEmpty) {
      return 'Please confirm your password';
    }
    if (this != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
