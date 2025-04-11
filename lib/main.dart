import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'package:spacecourse_app/screens/auth_screen.dart';
import 'screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpaceCourse',
      home: const OnboardingScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(), // 👈 this is what we navigate to
        '/signup': (context) => const SignUpScreen(), // (optional)
      },
    );
  }
}

