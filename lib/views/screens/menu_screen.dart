import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          _buildMenuItem(context, 'Danh mục sản phẩm', '/category',
              Icons.category, [Colors.blue[500]!, Colors.blueAccent]),
          _buildMenuItem(context, 'Giỏ hàng', '/cart', Icons.shopping_cart,
              [Colors.green[500]!, Colors.greenAccent]),
          _buildMenuItem(context, 'Danh sách yêu thích', '/wishlist',
              Icons.favorite, [Colors.red[500]!, Colors.redAccent]),
          _buildMenuItem(context, 'Tìm kiếm', '/search', Icons.search,
              [Colors.orange[500]!, Colors.orangeAccent]),
          _buildMenuItem(context, 'Đơn hàng', '/order', Icons.shop,
              [Colors.purple[500]!, Colors.purpleAccent]),
          _buildMenuItem(context, 'Thông báo tin nhắn', '/chat', Icons.chat,
              [Colors.indigo[500]!, Colors.indigoAccent]),
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
                style: GoogleFonts.getFont(
                  'Roboto',
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
