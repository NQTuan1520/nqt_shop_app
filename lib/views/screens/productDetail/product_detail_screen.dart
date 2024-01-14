import 'dart:async';
import 'package:custom_rating_bar/custom_rating_bar.dart' as rate;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/models/productDetailModel.dart';
import 'package:nqt_shop_app/views/screens/productDetail/vendor_store_detail_screen.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/cupertino.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controller/provider/cart_provider.dart';
import '../inner_screens/all_reviews_screen.dart';
import '../inner_screens/inner_chat_screen.dart';

class ProductDetailScreen extends riverpod.ConsumerStatefulWidget {
  final dynamic productData;

  ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends riverpod.ConsumerState<ProductDetailScreen> {
  double calculateAverageRating(List<double> ratings) {
    if (ratings.isEmpty) {
      return 0.0;
    }

    double total = 0.0;
    for (double rating in ratings) {
      total += rating;
    }

    return total / ratings.length;
  }


  final String message = 'Hello from my Flutter app!';
  double bottomPadding = 0;
  late GoogleMapController mapController;
  final Geolocator geolocator = Geolocator();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  Future<void> getProductPhoneNumber() async {
    try {
      var productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productData['productID'])
          .get();

      if (productDoc.exists) {
        var phoneNumber = productDoc.data()?['phoneNumber'];

        if (phoneNumber != null) {
          callSeller(phoneNumber);
        } else {
          throw 'Số điện thoại không có giá trị hoặc trống';
        }
      } else {
        throw 'Tài liệu không tồn tại';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void callSeller(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';

    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch phone';
    }
  }

  int _imageIndex = 0;
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where(
      'category',
      isEqualTo: widget.productData['category'],
    )
        .snapshots();
    // double? latitude = Provider.of<AppData>(context).pickUpAddress?.latitude;
    //
    // double? logitude = Provider.of<AppData>(context).pickUpAddress?.longitude;
    final _cartProvider = ref.read(cartProvider.notifier);

    // LatLng customerLatLng = LatLng(
    //     latitude!, logitude!); // Replace with customer address coordinates
    // LatLng vendorLatLng =
    //     LatLng(widget.productData['latitude'], widget.productData['longitude']);
    bool isInCart =
        _cartProvider.getCartItems.containsKey(widget.productData['productID']);
    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            widget.productData['productName'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: PhotoView(
                        imageProvider: NetworkImage(
                          widget.productData['imageUrl'][_imageIndex],
                        ),
                      )),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['imageUrl'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _imageIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.pink.shade900,
                                  )),
                                  height: 60,
                                  width: 60,
                                  child: Image.network(
                                      widget.productData['imageUrl'][index]),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_mall),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.productData['productName'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '\$ ' +
                          widget.productData['productPrice'].toStringAsFixed(3),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Mô tả Sản phẩm',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.productData['description'],
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              letterSpacing: 3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Số lượng sản phẩm',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.productData['quantity'].toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.pinkAccent,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    widget.productData['category'] == 'clothes' ||
                            widget.productData['category'] == 'shoes'
                        ? Column(
                          children: [
                            Text(
                              'Size sản phẩm:',
                              style: GoogleFonts.getFont(
                                'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.pinkAccent
                              ),
                            ),
                            Container(
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.productData['sizeList'].length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: _selectedSize == widget.productData['sizeList'][index]
                                              ? Colors.pink
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedSize = widget
                                                      .productData['sizeList']
                                                  [index];
                                            });

                                          },
                                          child: Center(
                                            child: Text(
                                              widget.productData['sizeList']
                                                  [index],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VendorStoreDetail(
                      vendorData: widget.productData,
                    );
                  }));
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.productData['storeImage'],
                  ),
                ),
                title: Text(
                  widget.productData['businessName'].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                subtitle: Text(
                  'XEM HỒ SƠ NGƯỜI BÁN',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('productReviews')
                    .where('productID',
                        isEqualTo: widget.productData['productID'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<double> ratings = [];
                    if (snapshot.data!.docs.isEmpty) {
                      // No reviews available

                      return Center(
                        child: Text(
                          'Không có đánh giá cho sản phẩm này',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      );
                    } else {
                      // Reviews are available
                      for (var doc in snapshot.data!.docs) {
                        double rating = doc['rating'];
                        ratings.add(
                          rating,
                        );
                      }

                      double averageRating = calculateAverageRating(ratings);
                      int totalReviews = ratings.length;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            RatingSummary(
                              counter: totalReviews,
                              average: averageRating,
                              showAverage: true,
                              counterFiveStars: 5,
                              counterFourStars: 4,
                              counterThreeStars: 2,
                              counterTwoStars: 1,
                              counterOneStars: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                height: 50,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    final mainData = snapshot.data!.docs[index];
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            mainData['buyerPhoto'],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          mainData['fullName'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink,
                                          ),
                                        ),
                                        Text(
                                          mainData['review'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        rate.RatingBar.readOnly(
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          initialRating: mainData['rating'],
                                          maxRating: 5,
                                        )
                                      ],
                                    );
                                  }),
                                  separatorBuilder: (_, index) => SizedBox(
                                    width: 20,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllReviewsScreen(
                                      productID:
                                          widget.productData['productID'],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Xem tất cả đánh giá',
                                style: GoogleFonts.getFont(
                                  'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    // Error in retrieving data
                    return Text('Error: ${snapshot.error}');
                  }

                  // Data is still loading
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: 280,
              //     decoration: BoxDecoration(
              //       color: Colors.grey,
              //     ),
              //     child: GoogleMap(
              //       polylines: {
              //         Polyline(
              //           polylineId: PolylineId('customer_vendor_id'),
              //           points: [
              //             customerLatLng,
              //             vendorLatLng,
              //           ],
              //           color: Colors.pink,
              //           width: 4,
              //         )
              //       },
              //       markers: Set<Marker>.from([
              //         Marker(
              //           markerId: MarkerId('seller_store'),
              //           position: LatLng(widget.productData['latitude'],
              //               widget.productData['longitude']),
              //           infoWindow: InfoWindow(title: 'Seller Location'),
              //           onTap: () {
              //             // Handle marker tap event
              //           },
              //         ),
              //       ]),
              //       circles: Set<Circle>.from([
              //         Circle(
              //           circleId: CircleId('circle_1'),
              //           // Provide a unique ID for the circle
              //           center: LatLng(widget.productData['latitude'],
              //               widget.productData['longitude']),
              //           // Set the center position of the circle
              //           radius: 1000,
              //           // Set the radius of the circle in meters
              //           fillColor: Colors.pink.withOpacity(0.2),
              //           // Set the fill color of the circle
              //           strokeColor: Colors.pink,
              //           // Set the stroke color of the circle
              //           strokeWidth: 2, // Set the stroke width of the circle
              //         ),
              //       ]),
              //       mapType: MapType.normal,
              //       initialCameraPosition: CameraPosition(
              //           zoom: 14,
              //           target: LatLng(widget.productData['latitude'],
              //               widget.productData['longitude'])),
              //       onMapCreated: (GoogleMapController controller) {
              //         setState(() {
              //           _controller.complete(controller);
              //         });
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 70,
              ),
              Text(
                'Related Products',
                style: GoogleFonts.roboto(
                  fontSize: 17,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return Container(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        return ProductDetailModel(
                          productData: productData, fem: fem,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomSheet: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (widget.productData['quantity'] == 0) {
                      return; // Not taking action when the product is out of stock
                    }

                    if (_cartProvider.getCartItems
                        .containsKey(widget.productData['productID'])) {
                      return; // Not taking action when the product is already in the cart
                    }

                    if (widget.productData['category'] != 'clothes' &&
                        widget.productData['category'] != 'shoes') {
                      _cartProvider.addProductToCart(
                        widget.productData['productName'],
                        widget.productData['productID'],
                        widget.productData['imageUrl'],
                        widget.productData['quantity'],
                        widget.productData['productPrice'],
                        widget.productData['vendorId'],
                        '',
                        widget.productData['shippingCharge']
                      );
                      isInCart =
                          true; // Update the status of the product as added to the cart
                      setState(() {});

                      Get.snackbar(
                        'SẢN PHẨM ĐÃ ĐƯỢC THÊM',
                        'Bạn đã thêm ${widget.productData['productName']} vào giỏ hàng',
                        margin: EdgeInsets.all(20),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.pink.shade900,
                        colorText: Colors.white,
                      );
                    } else {
                      if (_selectedSize == null) {
                        // Display a notification if the size hasn't been selected
                        Get.snackbar(
                          'SIZE SẢN PHẨM',
                          'Vui lòng chọn một size',
                          margin: EdgeInsets.all(20),
                          backgroundColor: Colors.pink.shade900,
                          colorText: Colors.white,
                        );
                      } else {
                        // Add the product to the cart if the size has been selected
                        _cartProvider.addProductToCart(
                          widget.productData['productName'],
                          widget.productData['productID'],
                          widget.productData['imageUrl'],
                          widget.productData['quantity'],
                          widget.productData['productPrice'],
                          widget.productData['vendorId'],
                          _selectedSize!,
                          widget.productData['shippingCharge'],
                        );

                        isInCart =
                        true; // Update the status of the product as added to the cart
                        setState(() {});

                        Get.snackbar(
                          'SẢN PHẨM ĐÃ ĐƯỢC THÊM',
                          'Bạn đã thêm ${widget.productData['productName']} vào giỏ hàng',
                          margin: EdgeInsets.all(20),
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.pink.shade900,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isInCart ||
                              _cartProvider.getCartItems.containsKey(
                                  widget.productData['productID']) ||
                              widget.productData['quantity'] == 0
                          ? Colors.grey
                          : Colors.pink.shade900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Icon(CupertinoIcons.cart,
                              color: Colors.white, size: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: widget.productData['quantity'] == 0
                              ? Text(
                                  'SẢN PHẨM HẾT HÀNG',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                )
                              : _cartProvider.getCartItems.containsKey(
                                      widget.productData['productID'])
                                  ? Text(
                                      'TRONG GIỎ HÀNG',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    )
                                  : Text(
                                      'THÊM VÀO GIỎ HÀNG',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InnerChatScreen(
                      sellerID: widget.productData['vendorId'],
                      buyerID: FirebaseAuth.instance.currentUser!.uid,
                      productID: widget.productData['productID'],
                      productName: widget.productData['productName'],
                    );
                  }));
                },
                icon: Icon(
                  CupertinoIcons.chat_bubble,
                  color: Colors.pink,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  getProductPhoneNumber();
                },
                icon: Icon(
                  CupertinoIcons.phone,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
        ));
  }
}

class RatingBar {}
