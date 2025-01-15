import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/forgotpassword.dart';
import 'package:my_flutter_app/pages/signup.dart';
import 'package:my_flutter_app/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bottomnav.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

String email="", password="";
final _formkey= GlobalKey<FormState>();
TextEditingController useremailcontroller= new TextEditingController();
TextEditingController userpasswordcontroller= new TextEditingController();

// userLogin() async {
//   try {
//     // Đăng nhập với email và mật khẩu
//     UserCredential userCredential = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(email: email, password: password);
//
//     // Truy xuất thông tin người dùng từ Firestore
//     // DocumentSnapshot userDoc = await FirebaseFirestore.instance
//     //     .collection("users")
//     //     .doc(userCredential.user!.uid)
//     //     .get();
//
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection("users")
//         .doc(userCredential.user!.uid)
//         .get();
//
//     if (userDoc.exists) {
//       // Người dùng tồn tại, xử lý logic sau khi đăng nhập
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           "Đăng nhập thành công!",
//           style: TextStyle(fontSize: 18, color: Colors.black),
//         ),
//       ));
//       // Chuyển đến màn hình chính hoặc dashboard
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context) =>  BottomNav())); // Thay BottomNav bằng màn hình chính của bạn
//     } else {
//       // Không tìm thấy người dùng trong Firestore
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           "Tài khoản không tồn tại trong hệ thống!",
//           style: TextStyle(fontSize: 18, color: Colors.white),
//         ),
//       ));
//     }
//   } on FirebaseAuthException catch (e) {
//     // Xử lý lỗi từ FirebaseAuth
//     if (e.code == 'user-not-found') {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           "Không tìm thấy người dùng!",
//           style: TextStyle(fontSize: 18, color: Colors.black),
//         ),
//       ));
//     } else if (e.code == 'wrong-password') {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           "Sai mật khẩu!",
//           style: TextStyle(fontSize: 18, color: Colors.black),
//         ),
//       ));
//     }
//   }
// }

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      // Nếu đăng nhập thành công, điều hướng đến BottomNav
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Đăng nhập thành công!",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ));
    }on FirebaseAuthException catch (e){
      if (e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Không tìm thấy User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )));
      } else if (e.code=='wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Mật khẩu sai",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(211, 10, 124, 0),
                        Color.fromARGB(255, 197, 240, 197),
                      ])),
            ),
            Container(
              margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Text("Log In"),
            ),
            Container(
              margin: EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "images/logo.png",
                      width: MediaQuery.of(context).size.width / 1.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Đăng nhập",
                              style: AppWidget.HeadLineTextFieldStyle(),
                            ),
                            TextFormField(
                              controller: useremailcontroller,
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return 'Hãy nhập email của bạn';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                  prefixIcon: Icon(Icons.email_outlined)),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: userpasswordcontroller,
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return 'Hãy nhập mật khẩu của bạn';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Mật khẩu',
                                  hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                  prefixIcon: Icon(Icons.password_outlined)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text("Quên mật khẩu?",
                                    style: AppWidget.semiBoldTextFieldStyle()),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            GestureDetector(
                              onTap: (){
                                if(_formkey.currentState!.validate()){
                                  setState(() {
                                    email = useremailcontroller.text;
                                    password =userpasswordcontroller.text;
                                  });

                                }
                                userLogin();
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                elevation: 5,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 114, 207, 135),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Text(
                                        "Đăng nhập",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins1',
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      "Chưa có tài khoản hả?\n         Đăng ký ngay",
                      style: AppWidget.ssemiBoldTextFieldStyle(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
