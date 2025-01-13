import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Phương thức để xóa người dùng
  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print("User deleted successfully");
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Phương thức để đăng xuất
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      print("User signed out successfully");

      // Điều hướng đến màn hình đăng nhập
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
