import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/service/shared_pref.dart';

class UserListOrder extends StatefulWidget {
  const UserListOrder({Key? key}) : super(key: key);

  @override
  State<UserListOrder> createState() => _UserListOrderState();
}

class _UserListOrderState extends State<UserListOrder> {
  String? userId;
  Stream<QuerySnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    loadUserOrders();
  }

  Future<void> loadUserOrders() async {
    userId = await SharedPreferenceHelper().getUserId();
    if (userId != null) {
      orderStream = FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .snapshots();
      setState(() {});
    }
  }

  String getStatusLabel(int status) {
    switch (status) {
      case 0:
        return "Đã hủy";
      case 1:
        return "Đã đặt";
      case 2:
        return "Đã xác nhận";
      case 3:
        return "Đang giao";
      case 4:
        return "Thành công";
      default:
        return "Không rõ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách đơn hàng"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var orders = snapshot.data.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var data = order.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Đơn hàng: ${order.id}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Số điện thoại: ${data['phone']}"),
                      Text("Địa chỉ: ${data['address']}"),
                      Text("Tổng tiền: ${data['totalAmount']} VND"),
                      Text("Trạng thái: ${getStatusLabel(data['status'])}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
     }
}
