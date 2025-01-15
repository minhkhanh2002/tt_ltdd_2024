import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/home.dart';
import 'package:my_flutter_app/pages/order.dart';
import 'package:my_flutter_app/pages/profile.dart';
import 'package:my_flutter_app/pages/wallet.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;
  late Wallet wallet;

  @override
  void initState() {
    super.initState();
    homepage = const Home();
    order = const Order();  // Initialize Order page
    profile = const Profile();
    wallet = const Wallet();

    // Initialize the list of pages
    pages = [homepage, order, wallet, profile];
    currentPage = homepage; // Default page is homepage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;  // Update the selected index
            currentPage = pages[currentTabIndex]; // Change the page
          });
        },
        items: const [
          Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,  // Shopping bag icon for order
            color: Colors.white,
          ),
          Icon(
            Icons.wallet_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outlined,
            color: Colors.white,
          ),
        ],
      ),
      body: currentPage, // Dynamically load the selected page
    );
  }
}
