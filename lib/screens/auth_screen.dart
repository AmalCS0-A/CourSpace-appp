import 'package:flutter/material.dart';
// Make sure your Google icon is in this path
// and declared in pubspec.yaml
// import 'your_google_sign_in_logic_here.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5DF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Toggle
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    // Sign In
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
                    // Sign Up
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
              ),
              const SizedBox(height: 32),
              Expanded(
                child: showSignUp ? buildSignUpForm() : buildSignInForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUpForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hello there !!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("We’re so excited to have you here!\nlet’s Build something Great Together"),
          const SizedBox(height: 24),
          const TextField(decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person))),
          const TextField(decoration: InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email))),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock))),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Sign Up logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92A89F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              ),
              child: const Text("Sign up", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          // Divider with Text
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1)),
              SizedBox(width: 8),
              Text("or continue with"),
              SizedBox(width: 8),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () {
                // Google Sign-In logic here
              },
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
          ),
        ],
      ),
    );
  }

  Widget buildSignInForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome back 👋",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("Log in to continue your journey!"),
          const SizedBox(height: 24),
          const TextField(decoration: InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email))),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Sign In logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF92A89F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              ),
              child: const Text("Sign in", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(child: Divider(thickness: 1)),
              SizedBox(width: 8),
              Text("or continue with"),
              SizedBox(width: 8),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () {
                // Google Sign-In logic here
              },
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
          ),
        ],
      ),
    );
  }
}
