import 'package:flutter/material.dart';
import 'package:nqt_shop_app/views/screens/widget/banner_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/beauty_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/category_item.dart';
import 'package:nqt_shop_app/views/screens/widget/customAppBar.dart';
import 'package:nqt_shop_app/views/screens/widget/men_shoes.dart';
import 'package:nqt_shop_app/views/screens/widget/new_products_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/reuseText_widget.dart';
import 'package:nqt_shop_app/views/screens/widget/vendor_stores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
              VendorStore(),
              CategoryItem(),
              ResuseTextWidget(
                title: 'All Products',
              ),
              NewProductWidget(),
              ResuseTextWidget(
                title: "Men's Shoes",
              ),
              MenShoes(),
              ResuseTextWidget(
                title: 'Beauty',
              ),
              BeautyWidget(),
            ],
          ),
        ));
  }
}
