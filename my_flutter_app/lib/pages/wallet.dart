import 'package:flutter/material.dart';
import 'package:my_flutter_app/widget/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(children: [

        Material(
            elevation: 2,
            child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(child: Text("Ví thanh toán", style: AppWidget.semiBoldTextFieldStyle(),)))),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                  child: Row(children: [
                    Image.asset("name", height: 60, width: 60,)
                  ],),
                ),
      ],),),
    );
  }
}
