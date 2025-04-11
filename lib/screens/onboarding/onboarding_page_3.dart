import 'package:flutter/material.dart';

class OnboardingPage3 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.arrow_back),
                Text("skip", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/phone_check.jpg', // ✅ Make sure the image exists in assets
            height: 250,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF6D8B7F), // ✅ Soft green background
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ready When You Are!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You’re all set to explore learning\npaths, find resources, and stay on track.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/auth'); // ✅ Go to auth screen (Sign In / Sign Up)
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text("Get Started"),
                      ),
                      const Spacer(),
                      const CircleAvatar(radius: 6, backgroundColor: Colors.grey),
                      const SizedBox(width: 8),
                      const CircleAvatar(radius: 6, backgroundColor: Colors.grey),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFFD8BFA2), // ✅ active dot
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
