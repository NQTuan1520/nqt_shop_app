import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/models/productDetailModel.dart';

class VendorStoreDetail extends StatelessWidget {
  final dynamic vendorData;

  const VendorStoreDetail({super.key, required this.vendorData});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: vendorData['vendorId'])
        .snapshots();
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .where('vendorId', isEqualTo: vendorData['vendorId'])
        .snapshots();
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LinearProgressIndicator(
              color: Colors.pink,
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 35,
                      ),
                    ),
                    SizedBox(
                      width: 90,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(vendorData['storeImage']),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      vendorData['businessName'],
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 28,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Điện thoại:" + " " + vendorData['phoneNumber'],
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _ordersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      double totalOrder = 0.0;
                      for (var orderItem in snapshot.data!.docs) {
                        totalOrder +=
                            orderItem['quantity'] * orderItem['productPrice'];
                      }

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Tổng số đơn hàng',
                                  style: GoogleFonts.getFont(
                                    'Roboto',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Tổng số tiền kiếm được',
                                  style: GoogleFonts.getFont(
                                    'Roboto',
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$' + ' ' + totalOrder.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            snapshot.data!.size >= 4
                                ? Row(
                                    children: [
                                      Text(
                                        'Đủ tiêu chuẩn',
                                        style: GoogleFonts.getFont(
                                          'Roboto',
                                          fontSize: 20,
                                        ),
                                      ),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.pink,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        'Chưa đủ tiêu chuẩn',
                                        style: GoogleFonts.getFont(
                                          'Roboto',
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Icon(
                                        Icons.not_interested,
                                        color: Colors.pink,
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.local_grocery_store_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Danh sách sản phẩm:',
                      style: GoogleFonts.getFont('Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              Container(
                height: 350,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: ProductDetailModel(
                        productData: productData,
                        fem: fem,
                      ),
                    );
                  },
                )
              ),
            ],
          ),
        );
      },
    ));
  }
}
