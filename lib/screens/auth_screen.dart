import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spacecourse_app/screens/choose_role_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignUp = true;
  bool isLoading = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handleGoogleSignIn() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'username': user.displayName ?? '',
            'email': user.email,
            'role': null,
            'createdAt': Timestamp.now(),
          });

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChooseRoleScreen(uid: user.uid)),
          );
        }
      }
    } catch (e) {
      showError("Google sign-in failed: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> handleSignUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showError("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      showError("Passwords do not match.");
      return;
    }

    setState(() => isLoading = true);
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'role': null,
        'createdAt': Timestamp.now(),
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChooseRoleScreen(uid: uid)),
      );
    } catch (e) {
      String message = "Sign up failed.";
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          message = "This email is already in use.";
        } else if (e.code == 'weak-password') {
          message = "Your password is too weak.";
        }
      }
      showError(message);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

Future<void> handleSignIn() async {
  final email = _signInEmailController.text.trim();
  final password = _signInPasswordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    showError("Please enter both email and password.");
    return;
  }

  setState(() => isLoading = true);

  try {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = result.user!.uid;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      setState(() => isLoading = false);
      showError("User data not found.");
      return;
    }

    final role = userDoc.data()?['role'];

    if (!mounted) return;

    if (role == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChooseRoleScreen(uid: uid)),
      );
    } else if (role == 'learner') {
      Navigator.pushReplacementNamed(context, '/learnerHome');
    } else if (role == 'contributor') {
      Navigator.pushReplacementNamed(context, '/contributorHome');
    } else {
      showError("Invalid role.");
    }
  } on FirebaseAuthException catch (e) {
    String message = "Sign in failed.";
    if (e.code == 'user-not-found') {
      message = "No user found for this email.";
    } else if (e.code == 'wrong-password') {
      message = "Incorrect password.";
    }
    showError(message);
  } catch (e) {
    // Print the real error for debug, but don’t show to user
    debugPrint('Unexpected sign in error: $e');
    showError("Something went wrong.");
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5DF),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    buildToggle(),
                    const SizedBox(height: 32),
                    Expanded(child: showSignUp ? buildSignUpForm() : buildSignInForm()),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showSignUp = false),
              child: Container(
                decoration: BoxDecoration(
                  color: showSignUp ? Colors.transparent : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: showSignUp ? Colors.black54 : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showSignUp = true),
              child: Container(
                decoration: BoxDecoration(
                  color: showSignUp ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: showSignUp ? Colors.black : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hello there !!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("We’re so excited to have you here!\nLet’s build something great together"),
          const SizedBox(height: 24),
          TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person))),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email))),
          TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
          TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock))),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92A89F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              ),
              child: const Text("Sign up", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          buildGoogleDivider(),
          const SizedBox(height: 16),
          buildGoogleButton(),
        ],
      ),
    );
  }

  Widget buildSignInForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome back 👋", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Log in to continue your journey!"),
          const SizedBox(height: 24),
          TextField(controller: _signInEmailController, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email))),
          TextField(controller: _signInPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92A89F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              ),
              child: const Text("Sign in", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          buildGoogleDivider(),
          const SizedBox(height: 16),
          buildGoogleButton(),
        ],
      ),
    );
  }

  Widget buildGoogleDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("or continue with"),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget buildGoogleButton() {
    return Center(
      child: GestureDetector(
        onTap: handleGoogleSignIn,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Image(
                image: AssetImage('assets/images/Logo-google-icon.png'),
                height: 24,
              ),
              SizedBox(width: 12),
              Text("Google"),
            ],
          ),
        ),
      ),
    );
  }
}
