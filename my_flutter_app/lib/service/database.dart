import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods{
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async{
    return await FirebaseFirestore.instance.collection('USERS').doc(id).set(userInfoMap);
  }

  UpdateUserWallet(String id, String amount) async{
    return await FirebaseFirestore.instance.collection('USER').doc(id).update({"Wallet": amount});
  }
}