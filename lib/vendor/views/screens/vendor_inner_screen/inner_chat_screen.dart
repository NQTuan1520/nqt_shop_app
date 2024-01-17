import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorChatPage extends StatefulWidget {
  final String productName;
  final String buyerID;
  final String sellerID;
  final String productID;
  final dynamic data;

  VendorChatPage({
    required this.buyerID,
    required this.sellerID,
    required this.productID,
    required this.data,
    required this.productName,
  });

  @override
  _VendorChatPageState createState() => _VendorChatPageState();
}

class _VendorChatPageState extends State<VendorChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = _firestore
        .collection('chats')
        .where('buyerID', isEqualTo: widget.buyerID)
        .where('sellerID', isEqualTo: widget.sellerID)
        .where('productID', isEqualTo: widget.productID)
        .orderBy('timestamp', descending: true)
        .limit(60)
        .snapshots();
  }

  void _sendMessage() async {
    DocumentSnapshot sellerDoc =
        await _firestore.collection('vendors').doc(widget.sellerID).get();
    DocumentSnapshot productDoc =
        await _firestore.collection('products').doc(widget.productID).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'productID': widget.productID,
        'buyerName': widget.data['buyerName'],
        'buyerPhoto': widget.data['buyerPhoto'],
        'sellerName':
            (sellerDoc.data() as Map<String, dynamic>)['businessName'],
        'sellerPhoto': (sellerDoc.data() as Map<String, dynamic>)['storeImage'],
        'buyerID': widget.buyerID,
        'sellerID': widget.sellerID,
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
        'productName':
            (productDoc.data() as Map<String, dynamic>)['productName'],
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn' + "> " + "" + widget.productName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages.'),
                  );
                }

                return ListView(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    String message = data['message'].toString();
                    String senderId = data['senderId']
                        .toString(); // Assuming 'senderId' field exists

                    // Determine if the sender is the buyer or the seller
                    bool isBuyer = senderId == widget.buyerID;
                    String buyerName = data['buyerName'].toString();
                    String sellerName = data['sellerName'].toString();

                    return Align(
                      alignment: isBuyer
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: isBuyer ? Colors.green : Colors.blue,
                          // Buyer: Green, Seller: Blue
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width *
                              0.7, // The maximum width limit for the message.
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isBuyer
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            isBuyer
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(data['buyerPhoto']),
                                  )
                                : SizedBox(),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: isBuyer
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isBuyer ? buyerName : sellerName,
                                        style: TextStyle(color: Colors.white70),
                                        softWrap: true,
                                      ),
                                      SizedBox(width: 4.0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.0),
                            !isBuyer
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(data['sellerPhoto']),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Soạn tin nhắn...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
