import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'account_screen.dart';
import 'home_screen.dart';
import 'menu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _pageIndex = 1;
  int _bottomNavIndex = 1;
  AnimationController? _animationController;

  List<Widget> _pages = [
    MenuScreen(),
    HomeScreen(),
    AccountScreen(),
  ];

  List<String> _tabTitles = [
    'Menu',
    'Trang chủ',
    'Tài khoản',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Offstage(
            offstage: _pageIndex != 0, // Hide non-HomeScreen when not selected
            child: TickerMode(
              enabled: _pageIndex == 0, // Stop updating widget when not selected
              child: _pages[_pageIndex],
            ),
          ),
          Offstage(
            offstage: _pageIndex == 0, // Hide the screens when selected
            child: _buildMainScreens(),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 20,
        child: AnimatedBottomNavigationBar.builder(
          itemCount: 3,
          tabBuilder: (index, isActive) {
            switch (index) {
              case 0:
                return _buildIcon(Icons.menu, isActive, _tabTitles[0]);
              case 1:
                return _buildIcon(Icons.home, isActive, _tabTitles[1]);
              case 2:
            return _buildIcon(Icons.account_circle, isActive, _tabTitles[2]);
              default:
                return Icon(Icons.error);
            }
          },
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          splashColor: Colors.orangeAccent,
          notchAndCornersAnimation: _animationController!,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
              _pageIndex = index; // Use the selected index as page index
            });
          },
        ),
      ),
    );
  }

  Widget _buildMainScreens() {
    return IndexedStack(
      index: _pageIndex,
      children: _pages,
    );
  }

  Widget _buildIcon(IconData icon, bool isActive, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: isActive ? 30 : 22, // Change size when selected
          color: isActive ? Colors.orangeAccent : Colors.black, // Change color when selected
        ),
        if (isActive)
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.black), // Text style for titles
          ),
        if (isActive)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orangeAccent, // Change border color when selected
            ),
          ),
      ],
    );
  }
}
