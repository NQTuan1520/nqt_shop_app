import 'package:flutter/material.dart';

class VendorMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_open),
            SizedBox(
              width: 5,
            ),
            Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuItem(context, 'Doanh thu', '/vendorEarnings',
              Icons.category, [Colors.red[500]!, Colors.redAccent]),
          _buildMenuItem(context, 'Đăng tải sản phẩm', '/vendorUpload',
              Icons.shopping_cart, [Colors.green[500]!, Colors.greenAccent]),
          _buildMenuItem(context, 'Đơn hàng', '/vendorOrders', Icons.shop,
              [Colors.purple[500]!, Colors.purpleAccent]),
          _buildMenuItem(context, 'Thông báo tin nhắn', '/vendorChat',
              Icons.chat, [Colors.indigo[500]!, Colors.indigoAccent]),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route,
      IconData icon, List<Color> gradientColors) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp,
              ),
            ),
            child: ListTile(
              leading: Icon(
                icon,
                color: Colors.white,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
