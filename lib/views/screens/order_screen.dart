import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatefulWidget {
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink.shade900,
        elevation: 0,
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
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
                            'Accepted',
                            style: TextStyle(color: Colors.pink.shade900),
                          )
                        : Text(
                            'Not Accepted',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                    trailing: Text(
                      'Amount' +
                          ' ' +
                          document['productPrice'].toStringAsFixed(2),
                      style: TextStyle(fontSize: 17, color: Colors.pink),
                    ),
                    subtitle: Text(
                      document['accepted'] == true
                          ? formatedDate(getDate(document['orderDate']))
                          : 'Not scheduled yet',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      'Order Details',
                      style: TextStyle(
                        color: Colors.pink.shade900,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text('View Order Details'),
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
                                  ('Quantity'),
                                  style: TextStyle(
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
                                Text('Schedule Delivery Date'),
                                if (document['accepted'] == true)
                                  Text(
                                    formatedDate(getDate(document['orderDate'])).toString(),
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estimated Delivery Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (document['estimatedDeliveryDate'] is Timestamp)
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(document['estimatedDeliveryDate'].toDate()),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                              ],
                            ),

                            ListTile(
                              title: Text(
                                'Buyer Details',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(document['fullName']),
                                  Text(document['telephone']),
                                  Text(document['email']),
                                  Text(document['placeName']),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (document['receiveItem'] == false)
                        if (document['accepted'] == true)
                            if (showReceivePackageButton(document['estimatedDeliveryDate']))
                        ElevatedButton(
                          onPressed: () async {
                            // Update 'receiveItem' field to true in Firestore
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(document['orderID'])
                                .update({'receiveItem': true});

                          },
                          child: Text('Receive Package'),
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
                                  title: Text('Error'),
                                  content: Text(
                                      'You have already reviewed this product.'),
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
                                  title: Text('Leave a Review'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _reviewTextController,
                                        decoration: InputDecoration(
                                          labelText: 'Your Review',
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
                                      child: Text('Submit'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text('Leave a Review'),
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
    return now.isAfter(deliveryDateTime.subtract(Duration(days: 4))); // To display the button when the delivery date has arrived
  }
  return false;
}





