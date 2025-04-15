import 'package:flutter/material.dart';
import 'package:spacecourse_app/screens/onboarding/onboarding_page_1.dart';
import 'onboarding_page_2.dart';
import 'onboarding_page_3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacecourse_app/main.dart'; // ⬅ for AuthWrapper

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OnboardingPage1(controller: _pageController),
      OnboardingPage2(controller: _pageController),
      OnboardingPage3(
        controller: _pageController,
        onDone: _handleDonePressed,
      ),
    ];
  }

  void _handleDonePressed() async {
    debugPrint("✅ onDone triggered from OnboardingPage3");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthWrapper()),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFF5F8670)
            : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (_, index) => _pages[index],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, _buildIndicator),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
