import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods{
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async{
    return await FirebaseFirestore.instance.collection('USERS').doc(id).set(userInfoMap);
  }

  UpdateUserWallet(String id, String amount) async{
    return await FirebaseFirestore.instance.collection('USERS').doc(id).update({"Wallet": amount});
  }

  Future addFoodItem(Map<String, dynamic> foodItemData) async {
    // Thêm món ăn vào collection 'foodItems'
    return await FirebaseFirestore.instance.collection('foodItems').add(foodItemData);
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
// Method to update food quantity in the user's cart
  Future<void> updateFoodQuantity(String userId, String foodId, String newQuantity) async {
    try {
      // Reference to the user's cart collection
      CollectionReference cartRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('cart');

      // Update the quantity of the food item in the cart
      await cartRef.doc(foodId).update({
        'Quantity': newQuantity,
      });
    } catch (e) {
      print('Error updating food quantity: $e');
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
}