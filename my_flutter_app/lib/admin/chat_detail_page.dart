import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;

  const ChatDetailPage({Key? key, required this.userName}) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _messagesCollection =
  FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.userName}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .where('sender', isEqualTo: widget.userName)
                  .orderBy('timestamp') // Sắp xếp tin nhắn theo thời gian
                  .snapshots(),
              builder: (context, snapshot) {
                // Kiểm tra trạng thái kết nối Firestore
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Kiểm tra khi không có dữ liệu hoặc dữ liệu trống
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageText = message['text'];
                    final senderName = message['sender'];
                    final timestamp = message['timestamp']?.toDate();
                    final formattedTime = timestamp != null
                        ? "${timestamp.hour}:${timestamp.minute}"
                        : "Unknown Time";

                    return ListTile(
                      title: Text(messageText),
                      subtitle: Text("$senderName at $formattedTime"),
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
                      hintText: 'Enter your message...',
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
      // Gửi tin nhắn với người gửi là "Admin" hoặc tên người dùng
      await _messagesCollection.add({
        'text': _messageController.text,
        'sender': 'Admin',  //  người gửi là admin
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }
}
