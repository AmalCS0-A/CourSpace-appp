import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up Method
  Future<String?> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;

      developer.log("✅ Created user: $uid");

      // Save to Firestore with role: null
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'role': null, // role will be selected later
        'createdAt': Timestamp.now(),
      });

      return null; // success
    } on FirebaseAuthException catch (e) {
      developer.log("❌ FirebaseAuthException: ${e.code} - ${e.message}", level: 1000);
      return e.message;
    } catch (e, stacktrace) {
      developer.log("❌ Unknown signup error: $e", stackTrace: stacktrace, level: 1000);
      return 'An unknown error occurred.';
    }
  }

  // Sign In Method
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      developer.log("❌ FirebaseAuthException: ${e.code} - ${e.message}", level: 1000);
      return e.message;
    } catch (e, stacktrace) {
      developer.log("❌ Unknown signin error: $e", stackTrace: stacktrace, level: 1000);
      return 'An unknown error occurred.';
    }
  }
}