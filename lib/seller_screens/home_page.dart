import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/seller_screens/account_page.dart';
import 'package:local_ease/seller_screens/insights_page.dart';
import 'package:local_ease/seller_screens/your_store_page.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  int _selectedIndex = 0;

  /// index Set State
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        /// Your Store Page
        const StoreListingPage(),

        /// Insights Page
        const InsightsPage(),

        /// Account Page
        const SellerAccountPage(),
      ].elementAt(_selectedIndex),

      ///Bottom Nav Bar of Main app
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12.8,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Your Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
