import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_flutter_app/widget/widget_support.dart';
import 'package:my_flutter_app/widget/app_constant.dart';
class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Center(child: Text("Ví thanh toán", style: AppWidget.semiBoldTextFieldStyle(),)))),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
              child: Row(children: [
                Image.asset("images/wallet.png", height: 60, width: 60,fit: BoxFit.cover,),
                SizedBox(width: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Số dư của bạn", style: AppWidget.LightTextFieldStyle(),),
                    SizedBox(height: 5,),
                    Text("100000"+" VND", style: AppWidget.boldTextFieldStyle(),),
                  ],),
              ],),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Nạp tiền", style: AppWidget.semiBoldTextFieldStyle(),),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              GestureDetector(
                onTap: (){
                  makePayment('10000');
                },
                child: Container(

                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFE9E2E2)), borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("10000"+ " VND", style: AppWidget.semiBoldTextFieldStyle(),),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE9E2E2)), borderRadius: BorderRadius.circular(5),
                ),
                child: Text("50000"+ " VND", style: AppWidget.semiBoldTextFieldStyle(),),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE9E2E2)), borderRadius: BorderRadius.circular(5),
                ),
                child: Text("100000"+ " VND", style: AppWidget.semiBoldTextFieldStyle(),),
              ),
              // Container(
              //   padding: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Color(0xFFE9E2E2)), borderRadius: BorderRadius.circular(5),
              //   ),
              //   child: Text("200000"+ " VND", style: AppWidget.semiBoldTextFieldStyle(),),
              // ),
            ],),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 12),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xFF008080), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text("Nạp tiền vào ví", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Poppins', fontWeight: FontWeight.bold),),),
            ),
          ],),
      ),
    );
  }

  Future<void> makePayment(String amount) async{
    try{
      paymentIntent = await createPaymentIntent(amount, 'VND');
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: 'Admin'
      )).then((value){});

    displayPaymentSheet(amount);

    }catch(e,s){
      print('exception: $e$s');
    }
  }

  //Màn hình hiển thị trạng thái thanh toán
  displayPaymentSheet(String amount) async {
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async {
        showDialog(context: context, builder: (_) =>
            AlertDialog(
              content: Column(children: [
                Row(children: [
                  Icon(Icons.check_circle, color: Colors.green,),
                  Text("Thanh toán thành công")
                ],)
              ],),
            ));

        paymentIntent = null;
      }).onError((error, stackTrace){
        print('Error is:---> $error $stackTrace');
      });

    }on StripeException catch(e) {
      print('Error is:--->$e');
      showDialog(context: context, builder: (_) =>
      const AlertDialog(
        content: Text("Giao dịch không thành công"),
      ));
    }catch (e){
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try{
      Map<String, dynamic> body={
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]':'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':'Bearer $secretKey',
          'Content-Type':'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    }catch(err){
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount){
    final calculatedAmount = (int.parse(amount)*100);
    return calculatedAmount.toString();
  }
}
