import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  final PageController controller;

  const OnboardingPage2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back),
                TextButton(
                  onPressed: () {
                    // Optionally skip onboarding
                  },
                  child: const Text("skip", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/person_computer.jpg', // <-- Update this path if needed
            height: 250,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF6D8B7F), // Green background like screenshot
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "We’ve Done the Work for You!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Whether online or in-person,\npaid or free, your learning\njourney just got easier",
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text("Next"),
                      ),
                      const Spacer(),
                      const CircleAvatar(radius: 6, backgroundColor: Colors.grey),
                      const SizedBox(width: 8),
                      const CircleAvatar(radius: 6, backgroundColor: Color(0xFFD8BFA2)), // active dot
                      const SizedBox(width: 8),
                      const CircleAvatar(radius: 6, backgroundColor: Colors.grey),
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
