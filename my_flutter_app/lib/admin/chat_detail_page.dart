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

                  .where('recipient', isEqualTo: widget.userName) // Lọc tin nhắn cho người dùng này
                  //.orderBy('timestamp', descending: true) // Sắp xếp tin nhắn theo thời gian mới nhất trước
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return Center(child: Text('Something went wrong!'));
                }
                if (!snapshot.hasData) {
                  return Center(child: Text("No data available"));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }


                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true, // Đảo ngược danh sách để tin nhắn mới nhất nằm ở cuối
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
                      tileColor: senderName == 'Admin'
                          ? Colors.grey[200] // Màu nền khác cho tin nhắn của Admin
                          : Colors.transparent,
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
      await _messagesCollection.add({
        'text': _messageController.text,
        'sender': 'Admin',  // Đây là tin nhắn từ admin
        'recipient': widget.userName, // Tin nhắn gửi đến người dùng hiện tại
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }
}
