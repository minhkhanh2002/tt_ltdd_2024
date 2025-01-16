import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('USERS')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection('USERS')
        .doc(id)
        .update({"Wallet": amount});
  }

  Future addFoodItem(Map<String, dynamic> foodItemData) async {
    // Thêm món ăn vào collection 'foodItems'
    return await FirebaseFirestore.instance
        .collection('foodItems')
        .add(foodItemData);
  }

  // Thêm món ăn vào giỏ hàng của người dùng (collection 'userCart')
  Future addFoodToCart(Map<String, dynamic> foodItemData, String userId) async {
    try {
      // Thêm món ăn vào giỏ hàng của người dùng
      await FirebaseFirestore.instance
          .collection('userCart')
          .doc(userId)
          .collection('items')
          .add(foodItemData);
      return 'Food added to cart';
    } catch (e) {
      print("Error adding food to cart: $e");
      return 'Error adding food to cart';
    }
  }

  //lưu thông tin đặt hàng
  Future<void> addOrder(Map<String, dynamic> orderData) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      print("Order added successfully!");
    } catch (e) {
      print("Error adding order: $e");
    }
  }

  // Lấy giỏ hàng của người dùng (dùng khi hiển thị giỏ hàng)
  Future getUserCart(String userId) async {
    return FirebaseFirestore.instance
        .collection('userCart')
        .doc(userId)
        .collection('items')
        .snapshots();
  }

  Future<void> updateCartItem({
    required String userId,
    required String docId,
    required int newQuantity,
    required int newTotal,
  }) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(userId)
        .collection('items')
        .doc(docId)
        .update({
      'Quantity': newQuantity.toString(),
      'Total': newTotal.toString(),
    });
  }
}
