import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    // We use a small delay to ensure the splash is visible for at least a brief moment
    Future.delayed(const Duration(seconds: 2), () {
      final authState = ref.read(authStateProvider);

      authState.when(
        data: (user) {
          if (user != null) {
            Navigator.of(context).pushReplacementNamed('/profile');
          } else {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        loading: () {
          // Keep waiting if loading
        },
        error: (err, stack) {
          Navigator.of(context).pushReplacementNamed('/login');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to navigate when data becomes available
    ref.listen(authStateProvider, (previous, next) {
      if (next is AsyncData) {
        final user = next.value;
        if (user != null) {
          Navigator.of(context).pushReplacementNamed('/profile');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                size: 80,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AuthTest',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Color(0xFF3B82F6),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
