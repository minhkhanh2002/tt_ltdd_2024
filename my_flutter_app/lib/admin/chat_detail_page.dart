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
          // StreamBuilder for user messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .where('sender', isEqualTo: widget.userName) // Tin nhắn từ người dùng
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return Center(child: Text('Something went wrong!'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No user messages yet"));
                }

                final userMessages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: userMessages.length,
                  reverse: true, // Đảo ngược danh sách để tin nhắn mới nhất nằm ở cuối
                  itemBuilder: (context, index) {
                    final message = userMessages[index];
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

          // StreamBuilder for admin messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .where('sender', isEqualTo: 'Admin') // Tin nhắn từ Admin
                  .where('recipient', isEqualTo: widget.userName) // Tin nhắn gửi đến người dùng
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return Center(child: Text('Something went wrong!'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No admin messages yet"));
                }

                final adminMessages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: adminMessages.length,
                  reverse: true, // Đảo ngược danh sách để tin nhắn mới nhất nằm ở cuối
                  itemBuilder: (context, index) {
                    final message = adminMessages[index];
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
