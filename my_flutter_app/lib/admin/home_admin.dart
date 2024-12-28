import 'package:flutter/material.dart';
import 'add_food.dart';

class HomeAdmin extends StatelessWidget {
  final String username = 'Admin';  // Tên người dùng, có thể thay thế bằng dữ liệu thực tế

  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          // Hiển thị nút hình tròn và menu popup
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  // Xử lý đăng xuất
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Log out', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ),
              ],
              child: CircleAvatar(
                radius: 20,  // Kích thước của vòng tròn
                backgroundColor: Colors.deepPurple,
                child: const Icon(
                  Icons.person,  // Biểu tượng người dùng
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Admin!",  // Chào mừng người dùng
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
                  // Mục Add Food Items
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddFood()),
                      );
                    },
                    leading: Image.asset(
                      "images/food/comtam.png",  // Hình ảnh có thể thay đổi nếu cần
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: const Text(
                      "Add Food Items",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text("Manage and add new food items."),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    tileColor: Colors.grey[200],
                  ),
                  // Bạn có thể thêm nhiều mục khác ở đây nếu cần
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
