import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_ease/screens/nearyou_page.dart';
import 'package:local_ease/screens/profile_page.dart';
import 'package:local_ease/screens/subscribed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        /// NearYou Page
        const NearYouPage(),

        /// Subscribed Page
        const SubscribedPage(),

        /// Profile Page
        const ProfilePage(),
      ].elementAt(_selectedIndex),

      ///Bottom Nav Bar of Main app
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12.8,
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            label: 'Near You',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star),
            label: 'Subscribed',
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
