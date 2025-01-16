import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderManager extends StatefulWidget {
  const OrderManager({Key? key}) : super(key: key);

  @override
  State<OrderManager> createState() => _OrderManagerState();
}

class _OrderManagerState extends State<OrderManager> {
  Stream<QuerySnapshot>? orderStream;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    orderStream = FirebaseFirestore.instance.collection('orders').snapshots();
    setState(() {});
  }

  void updateOrderStatus(String orderId, int newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': newStatus});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Cập nhật trạng thái thành công!"),
        backgroundColor: Colors.green,
      ),
    );
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
        title: Text("Quản lý đơn hàng"),
        backgroundColor: Colors.yellow,
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
              var orderId = order.id;
              var data = order.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Đơn hàng: $orderId",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Số điện thoại: ${data['phone']}"),
                      Text("Địa chỉ: ${data['address']}"),
                      Text("Tổng tiền: ${data['totalAmount']} VND"),
                      Text("Trạng thái: ${getStatusLabel(data['status'])}"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          DropdownButton<int>(
                            value: data['status'],
                            items: [
                              DropdownMenuItem(value: 0, child: Text("Đã hủy")),
                              DropdownMenuItem(value: 1, child: Text("Đã đặt")),
                              DropdownMenuItem(
                                  value: 2, child: Text("Đã xác nhận")),
                              DropdownMenuItem(
                                  value: 3, child: Text("Đang giao")),
                              DropdownMenuItem(
                                  value: 4, child: Text("Thành công")),
                            ],
                            onChanged: (newValue) {
                              if (newValue != null) {
                                updateOrderStatus(orderId, newValue);
                              }
                            },
                          ),
                        ],
                      ),
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
