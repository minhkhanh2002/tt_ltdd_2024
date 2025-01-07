import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/admin/admin_login.dart'; // Import trang đăng nhập admin

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _adminCodeController = TextEditingController();

  // Code admin để kiểm tra quyền admin
  final String adminCode = "admin123"; // Mã xác nhận admin

  // Hàm đăng ký người dùng và cấp quyền admin
  Future<void> registerAdmin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String adminCodeInput = _adminCodeController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        // Đăng ký người dùng mới với Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Nếu nhập mã admin đúng, cấp quyền admin
        if (adminCodeInput == adminCode) {
          // Thêm thông tin admin vào Firestore
          await FirebaseFirestore.instance.collection('Admin').doc(userCredential.user?.uid).set({
            'isAdmin': true,  // Đánh dấu người dùng là admin
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Admin account created!")));

          // Sau khi đăng ký thành công, chuyển về trang đăng nhập
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminLogin())  // Chuyển sang trang đăng nhập
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect admin code")));
        }

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededeb),
      body: Stack(
        children: [
          // Background container
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
            padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 53, 51, 51), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(MediaQuery.of(context).size.width, 110.0),
              ),
            ),
          ),
          // Register form
          Container(
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Let's start with\nAdmin!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50.0),
                          // Email TextField
                          _buildTextField(
                            controller: _emailController,
                            hintText: "Email",
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40.0),
                          // Password TextField
                          _buildTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40.0),
                          // Admin Code TextField
                          _buildTextField(
                            controller: _adminCodeController,
                            hintText: "Admin Code",
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Admin Code';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40.0),
                          // Register Button
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                registerAdmin();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required String? Function(String?) validator,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 5.0, bottom: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 160, 160, 147)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(color: Color.fromARGB(255, 160, 160, 147)),
          ),
        ),
      ),
    );
  }
}
