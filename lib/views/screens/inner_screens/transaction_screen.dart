import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  final String? orderID;


  TransactionScreen({Key? key, required this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.solidMoneyBill1),
            SizedBox(width: 8,),
            Text('Hoá Đơn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ],
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: FutureBuilder(
        // Fetch data from Firestore based on productID
        future: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('orderDate', descending: true)
            .where('orderID', isEqualTo: orderID)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else {
            var transactions = snapshot.data!.docs;

            if (transactions.isEmpty) {
              return Center(child: Text('Không có đơn hàng cho sản phẩm này.'));
            }

            var transaction = transactions[0];

            dynamic productImage = transaction['productImage'];
            String imageUrl = (productImage is String)
                ? productImage
                : (productImage is List)
                ? (productImage.isNotEmpty ? productImage[0] : '')
                : '';

            DateTime orderDate = (transaction['orderDate'] as Timestamp).toDate();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thành công',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            buildInfoRow('Sản phẩm:', transaction['productName']),
                            buildDivider(),
                            buildInfoRow('Tổng số tiền:', '\$${transaction['productPrice']}'),
                            buildDivider(),
                            buildInfoRow('Số lượng:', '${transaction['quantity']}'),
                            buildDivider(),
                            buildInfoRow('Tên người mua:', transaction['fullName']),
                            buildDivider(),
                            buildInfoRow('Địa chỉ:', transaction['placeName']),
                            buildDivider(),
                            buildInfoRow(
                              'Ngày đặt hàng:',
                              DateFormat('dd/MM/yyyy HH:mm').format(orderDate),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/cart'));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          child: Text(
            title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            content,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Divider(
      color: Colors.grey,
      thickness: 1,
      height: 16,
      indent: 0,
      endIndent: 16,
    );
  }
}
