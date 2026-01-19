import 'package:auth_flow_app/core/theme/app_theme.dart';
import 'package:auth_flow_app/firebase_options.dart';
import 'package:auth_flow_app/views/auth/login_view.dart';
import 'package:auth_flow_app/views/auth/registration_view.dart';
import 'package:auth_flow_app/views/profile/profile_view.dart';
import 'package:auth_flow_app/views/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // To use Firebase, first configure it via FlutterFire CLI:
  // https://firebase.google.com/docs/flutter/setup

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Flow App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegistrationView(),
        '/profile': (context) => const ProfileView(),
      },
    );
  }
}
