import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:nqt_shop_app/vendor/views/screens/edit_product_screen.dart';
import 'package:nqt_shop_app/vendor/views/screens/vendor_account_screen.dart';
import 'package:nqt_shop_app/vendor/views/screens/vendor_menu_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({Key? key}) : super(key: key);

  @override
  _MainVendorScreenState createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen>
    with TickerProviderStateMixin {
  int _pageIndex = 1;
  int _bottomNavIndex = 1;
  AnimationController? _animationController;

  List<Widget> _pages = [
    VendorMenuScreen(),
    EditProductScreen(),
    VendorAccountScreen(),
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
      body: Stack(
        children: [
          Offstage(
            offstage: _pageIndex != 0, // Hide non-HomeScreen when not selected
            child: TickerMode(
              enabled: _pageIndex == 0,
              // Stop updating widget when not selected
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
                return _buildIcon(
                    Icons.account_circle, isActive, _tabTitles[2]);
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
          color: isActive
              ? Colors.orangeAccent
              : Colors.black, // Change color when selected
        ),
        if (isActive)
          Text(
            title,
            style: TextStyle(
                fontSize: 12, color: Colors.black), // Text style for titles
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
