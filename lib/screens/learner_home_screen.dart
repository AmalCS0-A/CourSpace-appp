import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class LearnerHomeScreen extends StatefulWidget {
  const LearnerHomeScreen({super.key});

  @override
  LearnerHomeScreenState createState() => LearnerHomeScreenState();
}
class LearnerHomeScreenState extends State<LearnerHomeScreen> {
  String? _profileImageUrl; // Store image URL from Firestore
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _dob = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
bool _isValidDOB(String dobText) {
  try {
    final parts = dobText.split('/');
    if (parts.length != 3) return false;

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final dob = DateTime(year, month, day);
    final now = DateTime.now();

    if (dob.isAfter(now)) return false; // Can't be in the future
    if (dob.isAfter(DateTime(2013, 12, 31))) return false; // Must be born before 2014

    return true;
  } catch (e) {
    return false;
  }
}

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = userDoc.data();

    if (data != null) {
      setState(() {
        _email.text = data['email'] ?? '';
        _username.text = data['username'] ?? '';
        _dob.text = data['dob'] ?? '';
        _profileImageUrl = data['profileImage'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final uploadUrl = Uri.parse("https://api.cloudinary.com/v1_1/djp8t92hx/image/upload");
    final request = http.MultipartRequest('POST', uploadUrl);
    request.fields['upload_preset'] = 'flutter_unsigned_preset';
    request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = jsonDecode(res.body);
      final imageUrl = data['secure_url'];

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profileImage': imageUrl,
        });

        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
    } else {
      print("Upload failed: ${res.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCFDBD5), Color(0xFFA8B8AE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Fill your profile',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(0xFF5B7868),
                              backgroundImage: _profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                  : null,
                              child: _profileImageUrl == null
                                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit, size: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _profileField(icon: Icons.email, hint: 'E-mail', controller: _email),
                        const SizedBox(height: 16),
                        _profileField(icon: Icons.person, hint: 'Username', controller: _username),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2005, 1, 1),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFF708C7A),
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (pickedDate != null && mounted) {
                              setState(() {
                                _dob.text =
                                    "${pickedDate.day.toString().padLeft(2, '0')}/"
                                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                                    "${pickedDate.year}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: _profileField(
                              icon: Icons.calendar_today,
                              hint: 'Date of birth',
                              controller: _dob,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;

                            if (_username.text.trim().isEmpty || _dob.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please complete all fields')),
                              );
                              return;
                            }

                            if (!_isValidDOB(_dob.text.trim())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a valid date of birth')),
                              );
                              return;
                            }

                            if (user != null) {
                              await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                                'email': _email.text.trim(),
                                'username': _username.text.trim(),
                                'dob': _dob.text.trim(),
                              });

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile updated')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF708C7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          ),
child: const Text(
  'Next',
  style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xFF4B6F5A), // Adjusted green for your design
  ),
),

                        ),
                        const Spacer(), // pushes button up if there's extra space
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}


 Widget _profileField({
  required IconData icon,
  required String hint,
  required TextEditingController controller,
}) {
  return TextField(
    controller: controller,
    cursorColor: Color(0xFF708C7A), // Green cursor
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Color(0xFF708C7A)), // Icon in green
      labelText: hint,
      labelStyle: TextStyle(color: Colors.black), // Label stays black
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF708C7A)), // Green underline on focus
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // Grey underline when not focused
      ),
    ),
  );
}
}