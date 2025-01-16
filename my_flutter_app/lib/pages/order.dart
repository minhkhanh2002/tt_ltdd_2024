// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:my_flutter_app/service/database.dart';
// import 'package:my_flutter_app/service/shared_pref.dart';
// import 'package:my_flutter_app/widget/widget_support.dart';
//
// import 'bottomnav.dart';
//
// class Order extends StatefulWidget {
//   const Order({super.key});
//
//   @override
//   State<Order> createState() => _OrderState();
// }
//
// class _OrderState extends State<Order> {
//   String? id, wallet;
//   int total = 0, amount2 = 0;
//
//   void startTimer() {
//     Timer(Duration(seconds: 3), () {
//       amount2 = total;
//       setState(() {});
//     });
//   }
//
//   getthesharedpref() async {
//     id = await SharedPreferenceHelper().getUserId();
//     wallet = await SharedPreferenceHelper().getUserWallet();
//     setState(() {});
//   }
//
//   ontheload() async {
//     await getthesharedpref();
//     foodStream = await DatabaseMethods().getUserCart(id!);
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     ontheload();
//     startTimer();
//     super.initState();
//   }
//
//   Stream? foodStream;
//
//   Widget foodCart() {
//     return StreamBuilder(
//         stream: foodStream,
//         builder: (context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: snapshot.data.docs.length,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot ds = snapshot.data.docs[index];
//                     total = total + int.parse(ds["Total"]);
//                     return Container(
//                       margin: EdgeInsets.only(
//                           left: 20.0, right: 20.0, bottom: 10.0),
//                       child: Material(
//                         elevation: 5.0,
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10)),
//                           padding: EdgeInsets.all(10),
//                           child: Row(
//                             children: [
//                               Container(
//                                 height: 90,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Center(child: Text(ds["Quantity"])),
//                               ),
//                               SizedBox(
//                                 width: 20.0,
//                               ),
//                               ClipRRect(
//                                   borderRadius: BorderRadius.circular(60),
//                                   child: Image.network(
//                                     ds["Image"],
//                                     height: 90,
//                                     width: 90,
//                                     fit: BoxFit.cover,
//                                   )),
//                               SizedBox(
//                                 width: 20.0,
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     ds["Name"],
//                                     style: AppWidget.semiBoldTextFieldStyle(),
//                                   ),
//                                   Text(
//                                     ds["Total"] + " VND",
//                                     style: AppWidget.semiBoldTextFieldStyle(),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   })
//               : CircularProgressIndicator();
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(top: 60.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Material(
//                 elevation: 2.0,
//                 child: Container(
//                     padding: EdgeInsets.only(bottom: 10.0),
//                     child: Center(
//                         child: Text(
//                       "Giỏ hàng",
//                       style: AppWidget.HeadLineTextFieldStyle(),
//                     )))),
//             SizedBox(
//               height: 20.0,
//             ),
//             Container(
//                 height: MediaQuery.of(context).size.height / 2,
//                 child: foodCart()),
//             Spacer(),
//             Divider(),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Tổng tiền",
//                     style: AppWidget.boldTextFieldStyle(),
//                   ),
//                   Text(
//                     total.toString() + " VND",
//                     style: AppWidget.semiBoldTextFieldStyle(),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 // Kiểm tra số dư ví của người dùng trước khi thanh toán
//                 if (int.parse(wallet!) >= amount2) {
//                   // Tính số tiền còn lại trong ví sau khi trừ số tiền phải thanh toán
//                   int amount = int.parse(wallet!) - amount2;
//
//                   // Cập nhật ví người dùng trong Firestore
//                   await DatabaseMethods()
//                       .UpdateUserWallet(id!, amount.toString());
//
//                   // Lưu số dư ví mới vào SharedPreferences
//                   await SharedPreferenceHelper()
//                       .saveUserWallet(amount.toString());
//
//                   // Thông báo thanh toán thành công
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Thanh toán thành công!'),
//                     ),
//                   );
//
//                   // Quay lại trang Home sau khi thanh toán thành công
//                   // Navigator.pushAndRemoveUntil(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => Home()),
//                   //   (Route<dynamic> route) => false, // Xóa toàn bộ stack
//                   // );
//                   //
//                   //Navigator.popUntil(context, (route) => route.isFirst);
//                   //
//
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => BottomNav(selectedTabIndex: 0)),
//                     (route) => false,
//                   );
//                 } else {
//                   // Thông báo không đủ tiền
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Số dư không đủ để thực hiện giao dịch'),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 10.0),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(10)),
//                 margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
//                 child: Center(
//                     child: Text(
//                   "Thanh toán",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold),
//                 )),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/checkout.dart';
import 'package:my_flutter_app/service/database.dart';
import 'package:my_flutter_app/service/shared_pref.dart';
import 'package:my_flutter_app/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id;
  int total = 0;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    id = await SharedPreferenceHelper().getUserId();
    if (id != null) {
      foodStream = await DatabaseMethods().getUserCart(id!);
      setState(() {});
    }
  }

  Future<void> clearCart() async {
    if (id != null) {
      final cartItems = await FirebaseFirestore.instance
          .collection('userCart')
          .doc(id)
          .collection('items')
          .get();

      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }
    }
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        total = 0;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            int itemTotal = int.parse(ds["Total"]);
            total += itemTotal;

            return Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(ds["Quantity"])),
                      ),
                      SizedBox(width: 20.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          ds["Image"],
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds["Name"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                          Text(
                            "${ds["Total"]} VND",
                            style: AppWidget.semiBoldTextFieldStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Giỏ hàng",
                    style: AppWidget.HeadLineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: foodCart(),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tổng tiền",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  Text(
                    "$total VND",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                if (id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Checkout(
                        totalAmount: total,
                        userId: id!,
                        onOrderComplete:
                            clearCart, // Xóa giỏ hàng sau khi đặt hàng thành công
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Không tìm thấy người dùng!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "Đặt hàng",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
