import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/favourite_provider.dart';
import '../product_detail_screen.dart';

class ProductDetailModel extends ConsumerStatefulWidget {
  const ProductDetailModel({
    Key? key,
    required this.productData,
    required this.fem,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> productData;
  final double fem;

  @override
  _ProductDetailModelState createState() => _ProductDetailModelState();
}

class _ProductDetailModelState extends ConsumerState<ProductDetailModel> {
  @override
  Widget build(BuildContext context) {
    final _wishProvider = ref.read(favouriteProvider.notifier);
    final wishItems = ref.watch(favouriteProvider);

    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailScreen(productData: widget.productData),);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 72 * widget.fem,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffdddddd)),
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0f000000),
                    offset: Offset(0 * widget.fem, 4 * widget.fem),
                    blurRadius: 6 * widget.fem,
                  ),
                ],
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 48 * widget.fem,
                      height: 50 * widget.fem,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                        child: Image.network(
                          widget.productData['imageUrl'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.productData['productName'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Color(0xff000000),
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\$${widget.productData['productPrice'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 8,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    if (widget.productData['category'] == 'clothes' ||
                        widget.productData['category'] == 'shoes') {
                      return _wishProvider.addProductToWish(
                        widget.productData['productName'],
                        widget.productData['productID'],
                        widget.productData['imageUrl'],
                        widget.productData['quantity'],
                        widget.productData['productPrice'],
                        widget.productData['vendorId'],
                        '',
                        widget.productData['scheduleDate'],
                        widget.productData['latitude'],
                        widget.productData['longitude'],
                        widget.productData['businessName'],
                        widget.productData['storeImage'],
                        widget.productData['sizeList'],
                        widget.productData['category'],
                        widget.productData['description'],
                      );
                    } else {
                      _wishProvider.addProductToWish(
                        widget.productData['productName'],
                        widget.productData['productID'],
                        widget.productData['imageUrl'],
                        widget.productData['quantity'],
                        widget.productData['productPrice'],
                        widget.productData['vendorId'],
                        '',
                        widget.productData['scheduleDate'],
                        widget.productData['latitude'],
                        widget.productData['longitude'],
                        widget.productData['businessName'],
                        widget.productData['storeImage'],
                        "",
                        widget.productData['category'],
                        widget.productData['description'],
                      );
                    }
                  },
                  icon: _wishProvider.getwishItem
                      .containsKey(widget.productData['productID'])
                      ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                      : Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                )),
          )
        ],
      ),
    );
  }
}

