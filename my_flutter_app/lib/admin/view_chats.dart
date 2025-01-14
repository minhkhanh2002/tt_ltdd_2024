import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ViewChats extends StatelessWidget {
  const ViewChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Chats"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!.docs;
          Set<String> uniqueUserNames = {}; // Để tránh trùng tên người dùng

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final userName = message['sender']; // Tên người gửi (userName)

              // Kiểm tra xem người gửi có phải là bot không, nếu có thì bỏ qua
              if (userName == "Bot") {
                return SizedBox.shrink();
              }

              final lastMessage = message['text'] ?? "No messages yet"; // Tin nhắn cuối
              final lastTimestamp = message['timestamp']?.toDate().toString() ?? "No timestamp"; // Thời gian tin nhắn cuối

              // Nếu người dùng đã có trong danh sách thì không hiển thị lại
              if (!uniqueUserNames.contains(userName)) {
                uniqueUserNames.add(userName);  // Thêm tên người dùng vào set để tránh trùng lặp
                return ListTile(
                  title: Text(userName),
                  subtitle: Text("Last message: $lastMessage"),
                  trailing: Text(lastTimestamp),
                  onTap: () {
                    // Điều hướng đến trang chi tiết cuộc trò chuyện
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(userName: userName),
                      ),
                    );
                  },
                );
              } else {
                return SizedBox.shrink();  // Không hiển thị nếu tên người dùng đã có trong danh sách
              }
            },
          );
        },
      ),
    );
  }
}
