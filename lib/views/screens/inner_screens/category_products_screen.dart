import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nqt_shop_app/views/screens/widget/category_item.dart';

import '../../../models/categories_model.dart';
import '../productDetail/product_detail_screen.dart';
import '../../../models/productDetailModel.dart';

class CategoryProductScreen extends StatefulWidget {
  final dynamic categoryData;

  const CategoryProductScreen({super.key, this.categoryData});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreen();
}

class _CategoryProductScreen extends State<CategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where(
          'category',
          isEqualTo: widget.categoryData.categoryName,
        )
        .where('approved', isEqualTo: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.orange,
        title: Text(
          widget.categoryData.categoryName.toString(),
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.pink.shade900,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Chưa có sản phẩm nào \ntrong danh mục này',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
              ),
            );
          }

          return GridView.builder(
              itemCount: snapshot.data!.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 200 / 300),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailScreen(productData: productData);
                    }));
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Container(
                          height: 170,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                productData.get('imageUrl')[0],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productData.get('productName'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\$' +
                                productData
                                    .get('productPrice')
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
