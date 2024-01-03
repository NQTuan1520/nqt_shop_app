import 'package:flutter/material.dart';

import 'edit_products_tabs/published_tab.dart';
import 'edit_products_tabs/unpublished_tab.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.yellow.shade900,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_basket),
              SizedBox(width: 5,),
              Text(
                'Manage Products',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          bottom: TabBar(tabs: [
            Tab(
              child: Text('Products'),
            ),
          ]),
        ),
        body: TabBarView(children: [
          PublishedTab(),
        ]),
      ),
    );
  }
}
