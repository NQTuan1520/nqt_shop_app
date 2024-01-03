import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nqt_shop_app/views/screens/productDetail/product_detail_screen.dart';

import '../../models/wishlist_models.dart';
import '../../provider/favourite_provider.dart';



class WishListScreen extends ConsumerWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _wishProvider = ref.read(favouriteProvider.notifier);
    final wishItems = ref.watch(favouriteProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
        elevation: 0,
        title: Padding(
          padding: EdgeInsetsDirectional.only(start: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite, // Biểu tượng yêu thích
                color: Colors.black,
              ),
              SizedBox(width: 10), // Khoảng cách giữa biểu tượng và tiêu đề
              Text(
                'Wishlist Screen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _wishProvider.removeAllItems();
            },
            icon: Icon(
              CupertinoIcons.delete,
            ),
          ),
        ],
      ),
      body: wishItems.isNotEmpty
          ? ListView.builder(
          shrinkWrap: true,
          itemCount: wishItems.length,
          itemBuilder: (context, index) {
            final wishData = wishItems.values.toList()[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(productData: wishData.toMap()),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SizedBox(
                    height: 150,
                    child: Row(children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(wishData.imageUrl[0]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wishData.productName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '\$' +
                                  " " +
                                  wishData.price.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.pink,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _wishProvider.removeItem(wishData.productID);
                              },
                              icon: Icon(
                                Icons.cancel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            );
          })
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Wishlist is Empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "You haven't added any items to your wishlist yet. \nYou can add them from the home screen",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

