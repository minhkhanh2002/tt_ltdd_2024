import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String userImage =
      "https://example.com/default-avatar.jpg"; // Ảnh mặc định nếu không có avatar trong Firestore

  // Lấy dữ liệu người dùng từ Firebase Firestore
  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Lấy dữ liệu người dùng từ Firestore theo UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Cập nhật thông tin người dùng từ Firestore
        setState(() {
          userName = userDoc['name'] ?? "Chưa có tên";
          userEmail = userDoc['email'] ?? "Chưa có email";
          userPhone = userDoc['phone'] ?? "Chưa có số điện thoại";
          userImage = userDoc['avatar'] ??
              "https://example.com/default-avatar.jpg"; // Nếu không có avatar, dùng ảnh mặc định
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(); // Gọi hàm lấy dữ liệu khi trang được tạo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Thêm hành động chỉnh sửa hồ sơ tại đây
            },
          ),
        ],
      ),
      body: Center(
        // Sử dụng Center để căn giữa
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Căn giữa theo trục dọc
            crossAxisAlignment:
                CrossAxisAlignment.center, // Căn giữa theo trục ngang
            children: [
              // Ảnh đại diện
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(userImage),
              ),
              const SizedBox(height: 20),

              // Tên người dùng
              Text(
                userName.isEmpty ? 'Loading...' : userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Email người dùng
              Text(
                userEmail.isEmpty ? 'Loading...' : userEmail,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              // Số điện thoại người dùng
              Text(
                userPhone.isEmpty ? 'Loading...' : userPhone,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Nút đăng xuất
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); // Đăng xuất người dùng
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LogIn()), // Chuyển đến trang login.dart
                  );
                },
                child: const Text("Đăng xuất"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
