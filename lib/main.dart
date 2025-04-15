import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'package:spacecourse_app/screens/onboarding/onboarding_screen.dart';
import 'package:spacecourse_app/screens/auth_screen.dart';
import 'package:spacecourse_app/screens/choose_role_screen.dart';
import 'package:spacecourse_app/screens/learner_home_screen.dart';
import 'package:spacecourse_app/screens/contributor_home_screen.dart';

const bool alwaysShowOnboarding = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role Based App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LaunchScreen(),
      routes: {
        '/chooseRole': (context) => const ChooseRoleScreen(uid: ''),
        '/learnerHome': (context) => const LearnerHomeScreen(),
        '/contributorHome': (context) => const ContributorHomeScreen(),
      },
    );
  }
}

// 🔁 Launch screen that checks if onboarding is complete
class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
  final prefs = await SharedPreferences.getInstance();

  //  Force sign out to test the auth screen again
  await FirebaseAuth.instance.signOut();
    // Show onboarding if the user hasn't seen it yet or if we force show it
    if (alwaysShowOnboarding || !(prefs.getBool('seenOnboarding') ?? false)) {
      if (!mounted) return; // Prevent context usage if widget is unmounted

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            onDone: () async {
              await prefs.setBool('seenOnboarding', true);

              if (!mounted) return; // ✅ correctly using the State's `mounted`

Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const LaunchScreen()),
);



            },
          ),
        ),
      );
    } else {
      if (!mounted) return; // Prevent context usage if widget is unmounted
      setState(() {
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return const AuthWrapper();
  }
}

// 🔒 Wrapper to decide which screen to show after login
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Widget> _getHomeScreen(User user) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data == null || data['role'] == null) {
      return ChooseRoleScreen(uid: user.uid);
    } else if (data['role'] == 'learner') {
      return const LearnerHomeScreen();
    } else if (data['role'] == 'contributor') {
      return const ContributorHomeScreen();
    } else {
      return ChooseRoleScreen(uid: user.uid); // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: _getHomeScreen(snapshot.data!),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (futureSnapshot.hasError) {
                return const Scaffold(
                  body: Center(child: Text("Something went wrong.")),
                );
              }

              return futureSnapshot.data!;
            },
          );
        }

        return const AuthScreen(); // Your actual sign in/up screen
      },
    );
  }
}
