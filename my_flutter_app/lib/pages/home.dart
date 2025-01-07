import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/pages/details.dart';
import 'package:my_flutter_app/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool food = false, drink = false, fruits = false, ice_cream = false;

  // Hàm lấy dữ liệu món ăn từ Firestore
  Stream<QuerySnapshot> getFoodItems() {
    String category = '';
    if (food) {
      category = 'Food';
    } else if (drink) {
      category = 'Drink';
    } else if (fruits) {
      category = 'Fruit';
    } else if (ice_cream) {
      category = 'Ice_cream';
    }

    // Lọc món ăn dựa trên category
    if (category.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('foodItems')
          .where('category', isEqualTo: category)
          .snapshots();
    } else {
      // Nếu không chọn loại nào, lấy tất cả món ăn
      return FirebaseFirestore.instance.collection('foodItems').snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
              margin: const EdgeInsets.only(right: 20),
              child: showItem(),
            ),
            const SizedBox(
              height: 25,
            ),
            // Sử dụng StreamBuilder để hiển thị danh sách món ăn theo chiều ngang
            Container(
              height: 290, // Đặt chiều cao cố định cho hàng ngang
              child: StreamBuilder<QuerySnapshot>(
                stream: getFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No items available.'));
                  }

                  var foodItems = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      var foodItem = foodItems[index];
                      var name = foodItem['name'] ?? 'No name';
                      var price = foodItem['price'] ?? 'No price';
                      var imageUrl = foodItem['imageUrl'] ?? '';
                      var itemDetails = foodItem['details'] ?? 'No details available';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(),
                            ),
                          );
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
                                  Image.network(
                                    imageUrl,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    name,
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    itemDetails,
                                    style: AppWidget.LightTextFieldStyle(),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "$price vnđ",
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Thêm ListView theo chiều dọc
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No items available.'));
                  }

                  var foodItems = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      var foodItem = foodItems[index];
                      var name = foodItem['name'] ?? 'No name';
                      var price = foodItem['price'] ?? 'No price';
                      var imageUrl = foodItem['imageUrl'] ?? '';
                      var itemDetails = foodItem['details'] ?? 'No details available';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(),
                            ),
                          );
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
                                  Image.network(
                                    imageUrl,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    name,
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    itemDetails,
                                    style: AppWidget.LightTextFieldStyle(),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "$price vnđ",
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
