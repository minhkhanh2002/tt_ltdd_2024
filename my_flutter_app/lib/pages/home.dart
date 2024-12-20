import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/details.dart';
import 'package:my_flutter_app/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool food = false, drink = false, fruits = false, ice_cream = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 50, left: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Minh Khánh,", style: AppWidget.boldTextFieldStyle()),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Quán Ăn Sinh Diên", style: AppWidget.HeadLineTextFieldStyle()),
              Text("Ngon, bổ và tiện lợi.", style: AppWidget.LightTextFieldStyle()),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.only(right: 20), child: showItem()),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Details()));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "images/food/comtam.png",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Cơm tấm",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Ngon nhứt náck",
                                  style: AppWidget.LightTextFieldStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "30000vnđ",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "images/food/comtam.png",
                                height: 150,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                "Cơm tấm",
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Ngon nhứt náck",
                                style: AppWidget.LightTextFieldStyle(),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "30000vnđ",
                                style: AppWidget.semiBoldTextFieldStyle(),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "images/food/bunpo.png",
                          height: 120,
                          width: 120,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "Bún bò Huế đặc biệt thơm ngon mại dzô mại dzô",
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "mpao",
                                style: AppWidget.LightTextFieldStyle(),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text("25000vnđ",
                                  style: AppWidget.semiBoldTextFieldStyle()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            food = true;
            drink = false;
            fruits = false;
            ice_cream = false;

            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                    color: food ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "images/icons/food.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: food ? Colors.white : Colors.black,
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            food = false;
            drink = true;
            fruits = false;
            ice_cream = false;

            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                    color: drink ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "images/icons/drink.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: drink ? Colors.white : Colors.black,
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            food = false;
            drink = false;
            fruits = true;
            ice_cream = false;

            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                    color: fruits ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "images/icons/fruits.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: fruits ? Colors.white : Colors.black,
                )),
          ),
        ),
        GestureDetector(
          onTap: () {
            food = false;
            drink = false;
            fruits = false;
            ice_cream = true;

            setState(() {});
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                    color: ice_cream ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "images/icons/ice_cream.png",
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  color: ice_cream ? Colors.white : Colors.black,
                )),
          ),
        )
      ],
    );
  }
}
