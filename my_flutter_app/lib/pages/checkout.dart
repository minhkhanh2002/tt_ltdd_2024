import 'package:flutter/material.dart';
import 'package:my_flutter_app/service/database.dart';

class Checkout extends StatefulWidget {
  final int totalAmount;
  final String userId;
  final Function onOrderComplete;

  const Checkout({
    required this.totalAmount,
    required this.userId,
    required this.onOrderComplete,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isProcessing = false;

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      Map<String, dynamic> orderData = {
        "userId": widget.userId,
        "phone": _phoneController.text.trim(),
        "address": _addressController.text.trim(),
        "totalAmount": widget.totalAmount,
        "status": 1, // Thêm trường trạng thái đơn hàng
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      };

      // Lưu đơn hàng vào Firestore
      await DatabaseMethods().addOrder(orderData);

      setState(() {
        _isProcessing = false;
      });

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đặt hàng thành công!"),
          backgroundColor: Colors.green,
        ),
      );

      // Gọi hàm để xóa giỏ hàng
      widget.onOrderComplete();

      // Quay lại màn hình chính
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin đặt hàng"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập số điện thoại";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: "Địa chỉ nhận hàng",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng nhập địa chỉ";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "Tổng tiền: ${widget.totalAmount} VND",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              _isProcessing
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitOrder,
                      child: Text("Thanh toán"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
