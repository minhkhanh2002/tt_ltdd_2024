import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');
  late String _userName; // Tên người dùng
  bool _isFirstMessage = true; // Kiểm tra xem có phải tin nhắn đầu tiên không

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  // Lấy tên người dùng từ Firebase Authentication
  void _getUserName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? user.email ?? 'Anonymous'; // Sử dụng displayName nếu có, nếu không thì dùng email
      });
    } else {
      setState(() {
        _userName = 'Anonymous'; // Nếu chưa đăng nhập, sử dụng tên mặc định
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(message['sender']),
                      tileColor: message['sender'] == _userName
                          ? Colors.blue[50]
                          : Colors.grey[200], // Màu nền cho tin nhắn của người dùng và bot
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Gửi tin nhắn người dùng
      await _messagesCollection.add({
        'text': _messageController.text,
        'sender': _userName, // Sử dụng tên người dùng đã đăng nhập hoặc 'Anonymous'
        'recipient': 'Admin', // Gửi tin nhắn cho Admin (hoặc bot)
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();

      // Kiểm tra nếu đây là tin nhắn đầu tiên
      if (_isFirstMessage) {
        _isFirstMessage = false;
        // Gửi tin nhắn chào mừng từ bot
        await _messagesCollection.add({
          'text': "Chào bạn , tôi là bot. Có thể tôi giúp gì cho bạn?( Gõ giúp, giới thiệu về web hoặc thực đơn để biết thêm chi tiết , cảm ơn !)",
          'sender': "Bot",
          'recipient': _userName, // Gửi phản hồi từ bot tới người dùng
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      // Phản hồi tự động từ bot sau mỗi tin nhắn của người dùng
      _autoRespondToUser();
    }
  }

  // Phản hồi tự động từ bot
  void _autoRespondToUser() async {
    final userMessage = _messageController.text.toLowerCase();
    String botResponse = "";

    if (userMessage.contains("giúp")) {
      botResponse = "Tôi có thể giúp bạn với việc gì? Thực đơn, đặt món, hay thông tin khác?";
    } else if (userMessage.contains("giới thiệu") || userMessage.contains("thực đơn")) {
      botResponse = "Đây là menu của chúng tôi: Món ăn, đồ uống, trái cây, và kem. Bạn muốn xem món gì?";
    } else if (userMessage.contains("cảm ơn")) {
      botResponse = "Không có gì! Hãy để tôi biết nếu bạn cần thêm sự giúp đỡ.";
    } else if (userMessage.contains("giới thiệu về web")) {
      botResponse = "Web chúng tôi phục vụ các món ăn ngon, bổ và tiện lợi, giúp bạn thưởng thức các món ăn tuyệt vời mỗi ngày!";
    } else {
      botResponse = " Bạn vui lòng chờ phản hôi. cảm ơn !";
    }

    // Gửi phản hồi tự động từ bot
    await _messagesCollection.add({
      'text': botResponse,
      'sender': "Bot",  // Tin nhắn phản hồi từ bot
      'recipient': _userName, // Gửi phản hồi từ bot đến người dùng
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
