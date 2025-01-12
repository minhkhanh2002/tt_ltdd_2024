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

}