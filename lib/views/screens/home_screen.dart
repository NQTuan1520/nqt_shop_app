import 'package:flutter/material.dart';
import 'package:nqt_shop_app/views/screens/widget/banner_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/electronic_products_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/category_item.dart';
import 'package:nqt_shop_app/views/screens/widget/customAppBar.dart';
import 'package:nqt_shop_app/views/screens/widget/fashion_products_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/all_products_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/reuseText_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/vendor_stores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(),
          BannerArea(),
          // VendorStore(),
          CategoryItem(),
          ResuseTextWidget(
            title: 'Tất cả sản phẩm',
          ),
          NewProductWidget(),
          ResuseTextWidget(
            title: "Thời trang",
          ),
          FashionProductsWidget(),
          ResuseTextWidget(
            title: 'Điện Tử',
          ),
          ElectronicProductsWidget(),
        ],
      ),
    ));
  }
}
