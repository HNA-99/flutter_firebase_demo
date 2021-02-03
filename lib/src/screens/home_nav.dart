import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/search_view.dart';
import 'package:flutter_firebase_demo/src/services/user_management.dart';

import 'products_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      ProductScreen(),
      SearchScreen(),
      UserManagement().authorizeAccess(context),
      Container(
        color: Colors.green,
      )
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Products'),
            icon: Icon(Icons.dashboard),
            activeColor: Colors.red[700],
          ),
          BottomNavyBarItem(
            title: Text('Search'),
            icon: Icon(Icons.search),
            activeColor: Colors.purple[700],
          ),
          BottomNavyBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person),
            activeColor: Colors.pink[700],
          ),
          BottomNavyBarItem(
            title: Text('Blank'),
            icon: Icon(Icons.computer),
            activeColor: Colors.green[700],
          ),
        ],
      ),
    );
  }
}
