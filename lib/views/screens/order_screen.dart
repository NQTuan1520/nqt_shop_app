import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  static const routeName = '/order';

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  double rating = 0;

  final TextEditingController _reviewTextController = TextEditingController();

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  DateTime getDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      if (DateTime.tryParse(date) != null) {
        return DateTime.parse(date);
      }
    }
    return DateTime.now();
  }

  DateTime? convertToDate(dynamic input) {
    if (input is Timestamp) {
      return input.toDate();
    } else if (input is String && input.isNotEmpty) {
      return DateTime.tryParse(input);
    }
    return null;
  }

  Future<bool> hasUserReviewedProduct(String productID) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productID', isEqualTo: productID)
        .where('buyerID', isEqualTo: user!.uid)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/cart'));
          },
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.shopify,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Đơn mua",
              style: GoogleFonts.getFont(
                'Roboto',
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.pink.shade900),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Không có đơn mua',
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: document['accepted'] == true
                          ? Icon(Icons.delivery_dining)
                          : Icon(Icons.access_time),
                    ),
                    title: document['accepted'] == true
                        ? Text(
                            'Đã Chấp Nhận',
                            style: GoogleFonts.getFont('Roboto',
                                color: Colors.pink.shade900),
                          )
                        : Text(
                            'Chưa chấp nhận',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              color: Colors.red,
                            ),
                          ),
                    trailing: Text(
                      'Tổng tiền' +
                          ' ' +
                          document['productPrice'].toStringAsFixed(2) +
                          '' +
                          '\$',
                      style: GoogleFonts.getFont('Roboto',
                          fontSize: 17, color: Colors.pink),
                    ),
                    subtitle: Text(
                      document['accepted'] == true
                          ? formatedDate(getDate(document['orderDate']))
                          : 'Chưa chuyển hàng',
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      'Chi tiết đơn hàng',
                      style: GoogleFonts.getFont(
                        'Roboto',
                        color: Colors.pink.shade900,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      'Xem chi tiết đơn hàng',
                      style: GoogleFonts.getFont(
                        'Roboto',
                      ),
                    ),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.network(
                            document['productImage'][0],
                          ),
                        ),
                        title: Text(document['productName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  ('Số lượng'),
                                  style: GoogleFonts.getFont('Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  document['quantity'].toString(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ngày Nhận Đơn:',
                                  style: GoogleFonts.getFont(
                                    'Roboto',
                                  ),
                                ),
                                if (document['accepted'] == true)
                                  Text(
                                    formatedDate(getDate(document['orderDate']))
                                        .toString(),
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ngày Giao Hàng Dự kiến:',
                                  style: GoogleFonts.getFont(
                                    'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (document['estimatedDeliveryDate']
                                    is Timestamp)
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                        document['estimatedDeliveryDate']
                                            .toDate()),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
                            ),
                            ListTile(
                              title: Text(
                                'Chi tiết người mua',
                                style: GoogleFonts.getFont(
                                  'Roboto',
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tên:' + ' ' + document['fullName']),
                                  Text('SĐT:' + ' ' + document['telephone']),
                                  Text('Email:' + ' ' + document['email']),
                                  Text(
                                      'Địa chỉ:' + ' ' + document['placeName']),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (document['receiveItem'] == false)
                        if (document['accepted'] == true)
                          if (showReceivePackageButton(
                              document['estimatedDeliveryDate']))
                            ElevatedButton(
                              onPressed: () async {
                                // Update 'receiveItem' field to true in Firestore
                                await FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(document['orderID'])
                                    .update({'receiveItem': true});
                              },
                              child: Text(
                                'Đã nhận hàng',
                                style: GoogleFonts.getFont(
                                  'Roboto',
                                ),
                              ),
                            ),
                      if (document['receiveItem'] == true)
                        ElevatedButton(
                          onPressed: () async {
                            final productID = document['productID'];
                            final hasReviewed =
                                await hasUserReviewedProduct(productID);

                            if (hasReviewed) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Lỗi'),
                                  content: Text(
                                    'Bạn đã đánh giá sản phẩm này rồi.',
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Đánh giá',
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _reviewTextController,
                                        decoration: InputDecoration(
                                          labelText: 'Đánh giá của bạn',
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating: rating,
                                        // Set the initial rating value
                                        minRating: 1,
                                        // Minimum rating value
                                        maxRating: 5,
                                        // Maximum rating value
                                        direction: Axis.horizontal,
                                        // Horizontal or vertical display of rating stars
                                        allowHalfRating: true,
                                        // Allow half-star ratings
                                        itemCount: 5,
                                        // Number of rating stars to display
                                        itemSize: 24,
                                        // Size of each rating star
                                        unratedColor: Colors.grey,
                                        // Color of unrated stars
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        // Padding between rating stars
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        // Custom builder for rating star widget
                                        onRatingUpdate: (value) {
                                          rating = value;

                                          // Handle the rating update here
                                          // This callback will be triggered when the user updates the rating
                                          print(rating);
                                        },
                                      )
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        final review =
                                            _reviewTextController.text;

                                        await FirebaseFirestore.instance
                                            .collection('productReviews')
                                            .add({
                                          'productID': productID,
                                          'fullName': document['fullName'],
                                          'telephone': document['telephone'],
                                          'buyerPhoto': document['buyerPhoto'],
                                          'email': document['email'],
                                          'buyerID': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'rating': rating,
                                          'review': review,
                                          'timestamp': Timestamp.now(),
                                        }).whenComplete(() {});

                                        Navigator.pop(
                                            context); // Close the dialog
                                        _reviewTextController.clear();
                                        rating = 0;
                                      },
                                      child: Text(
                                        'Xác nhận',
                                        style: GoogleFonts.getFont(
                                          'Roboto',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Đánh giá',
                            style: GoogleFonts.getFont(
                              'Roboto',
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

bool showReceivePackageButton(dynamic estimatedDeliveryDate) {
  if (estimatedDeliveryDate != null && estimatedDeliveryDate is Timestamp) {
    DateTime deliveryDateTime = estimatedDeliveryDate.toDate();
    DateTime now = DateTime.now();
    print('Now: $now');
    print('Delivery Date: $deliveryDateTime');
    return now.isAfter(deliveryDateTime.subtract(Duration(
        days: 4))); // To display the button when the delivery date has arrived
  }
  return false;
}
