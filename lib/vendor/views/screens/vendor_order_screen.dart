import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';

class VendorOrderScreen extends StatefulWidget {
  @override
  State<VendorOrderScreen> createState() => _VendorOrderScreenState();
}

class _VendorOrderScreenState extends State<VendorOrderScreen> {
  bool isScheduled = false;
  bool showScheduleButton = false;

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _handleScheduleButtonClick(
      BuildContext context, String orderId) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Update 'Estimated Delivery Date' with the picked date
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'estimatedDeliveryDate': pickedDate});
    }
  }

  DateTime getDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.tryParse(date) ??
          DateTime.now();
    }
    return date;
  }

  DateTime convertToDate(String input) {
    try {
      return DateTime.parse(input);
    } catch (e) {
      print(e);
      // Return current date/time or any default value
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.yellow.shade900,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopify),
              SizedBox(width: 5,),
              Text(
                'My Orders',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _ordersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.yellow.shade900),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                bool accepted = document['accepted'];
                bool transferredToCarrier =
                    document['transferredToCarrier'] ?? false;
                String orderId = document['orderID'];
                dynamic estimatedDeliveryDate =
                    document['estimatedDeliveryDate'];

                return Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            if (document['estimatedDeliveryDate']
                                is Timestamp) {
                              await _firestore
                                  .collection('orders')
                                  .doc(document['orderID'])
                                  .update({'estimatedDeliveryDate': ""});
                            }
                            await _firestore
                                .collection('orders')
                                .doc(document['orderID'])
                                .update({
                              'accepted': false,
                              'transferredToCarrier': false,
                            });
                            setState(() {
                              isScheduled = false;
                              showScheduleButton = false;
                            });
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Reject',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            await _firestore
                                .collection('orders')
                                .doc(document['orderID'])
                                .update({
                              'accepted': true,
                              'transferredToCarrier': false,
                            });
                            setState(() {
                              // Accepted order, hide the 'Schedule' button, and display 'Transferred to Carrier'
                              isScheduled = false;
                              showScheduleButton = false;
                            });
                          },
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Accept',
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 14,
                              child: document['accepted'] == true
                                  ? Icon(Icons.delivery_dining)
                                  : Icon(Icons.access_time)),
                          title: document['accepted'] == true
                              ? Text(
                                  'Accepted',
                                  style:
                                      TextStyle(color: Colors.yellow.shade900),
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
                            style: TextStyle(fontSize: 17, color: Colors.blue),
                          ),
                          subtitle: Text(
                            formatedDate(getDate(document['orderDate'])),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Order Details',
                            style: TextStyle(
                              color: Colors.yellow.shade900,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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

                                  if (document['accepted'] != true)
                                    SizedBox.shrink(),
                                  // Hide when not accepted
                                  if (document['accepted'] == true)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Schedule Delivery Date',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          formatedDate(
                                              getDate(document['orderDate'])),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(document['fullName']),
                                        Text(document['telephone']),
                                        Text(document['email']),
                                        Text(document['placeName']),
                                        if (accepted &&
                                            !transferredToCarrier &&
                                            document['accepted'] == true)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await _firestore
                                                    .collection('orders')
                                                    .doc(document['orderID'])
                                                    .update({
                                                  'transferredToCarrier': true,
                                                });
                                                setState(() {
                                                  showScheduleButton =
                                                      true; // Display the 'Schedule' button.
                                                });
                                              },
                                              child: Text(
                                                  'Transferred to Carrier'),
                                            ),
                                          ),
                                        if (showScheduleButton)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                if (estimatedDeliveryDate
                                                    is String) {
                                                  DateTime deliveryDate =
                                                      convertToDate(
                                                          estimatedDeliveryDate);
                                                  // Update Firestore with the converted DateTime
                                                  _firestore
                                                      .collection('orders')
                                                      .doc(document['orderID'])
                                                      .update({
                                                    'estimatedDeliveryDate':
                                                        deliveryDate
                                                  });
                                                }
                                                setState(() {
                                                  isScheduled = true;
                                                  showScheduleButton =
                                                      true; // Hide the 'Schedule' button after it has been selected.
                                                });
                                                await _firestore
                                                    .collection('orders')
                                                    .doc(document['orderID'])
                                                    .update({
                                                  'transferredToCarrier': true,
                                                });
                                                _handleScheduleButtonClick(
                                                    context, orderId);
                                              },
                                              child: Text('Schedule'),
                                            ),
                                          ),
                                        if (transferredToCarrier || isScheduled)
                                          if (isScheduled)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Estimated Delivery Date',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  document['estimatedDeliveryDate'] !=
                                                          null
                                                      ? DateFormat('dd/MM/yyyy')
                                                          .format(document[
                                                                  'estimatedDeliveryDate']
                                                              .toDate())
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        if (document['receiveItem'] == true)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              'Package has been sent to user!',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ));
              }).toList(),
            );
          },
        ));
  }
}
