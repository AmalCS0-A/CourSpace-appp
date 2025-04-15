import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key, required this.uid});

  final String uid;

  Future<void> _handleRoleSelection(BuildContext context, String role) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        final docSnapshot = await docRef.get();

        if (!docSnapshot.exists) {
          // Create the user document first if it doesn't exist
          await docRef.set({
            'uid': user.uid,
            'email': user.email,
            'username': user.displayName ?? '', // fallback to empty
            'role': role,
            'createdAt': Timestamp.now(),
          });
        } else {
          // Just update the role
          await docRef.update({'role': role});
        }

        if (!context.mounted) return;

        Navigator.pushReplacementNamed(
          context,
          role == 'learner' ? '/learnerHome' : '/contributorHome',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update role: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8EFE6), Color(0xFF7E9A8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                const Text(
                  'How would you like to\ncontinue ?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE7B88D),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your role to get the best experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                _roleCard(
                  icon: Icons.edit,
                  title: 'Continue as a learner',
                  subtitle:
                      'Explore a wide range of courses, learn at your own pace, and enhance your skills with expert guidance!',
                  buttonText: 'Start learning',
                  onPressed: () => _handleRoleSelection(context, 'learner'),
                ),
                const SizedBox(height: 24),
                _roleCard(
                  icon: Icons.menu_book,
                  title: 'Continue as a contributor',
                  subtitle:
                      'Create and share courses while also accessing a variety of learning materials to expand your own knowledge.',
                  buttonText: 'Start Contributing',
                  onPressed: () => _handleRoleSelection(context, 'contributor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF708C7A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDAA06D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE7B88D),
                foregroundColor: const Color(0xFF5B7868),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
