import 'package:flutter/material.dart';

class ContributorHomeScreen extends StatelessWidget {
  const ContributorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFCFDBD5), Color(0xFFA8B8AE)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Tell Us More About You',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'You can skip any field you don’t want to fill',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  maxLines: 5,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Write something about yourself and your experiences',
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Social Media Links',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _socialField(icon: Icons.facebook, label: 'Facebook'),
              const SizedBox(height: 12),
              _socialField(icon: Icons.link, label: 'LinkedIn'),
              const SizedBox(height: 12),
              _socialField(icon: Icons.alternate_email, label: 'Twitter'),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF708C7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: const Text(
                    'Complete Profile',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialField({required IconData icon, required String label}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF5B7868),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Colors.black54),
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
