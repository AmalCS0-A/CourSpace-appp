import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  final PageController controller;
  const OnboardingPage1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.arrow_back),
              Text(
                'skip',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Image.asset(
          'assets/images/onboarding1.jpg',
          height: 250,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF6D8B7F), // Adjusted green background
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Algeria’s Learning Map—All in One App!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "No more getting lost in\nendless searches—find it all in\none tap.",
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
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text("Next"),
                    ),
                    const Spacer(),
                    const CircleAvatar(radius: 6, backgroundColor: Color(0xFFD1BFA8)), // Active
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 6, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 6, backgroundColor: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
