import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InnerChatScreen extends StatefulWidget {
  final String productName;
  final String buyerID;
  final String sellerID;
  final String productID;
  final dynamic data;

  InnerChatScreen(
      {required this.buyerID,
      required this.sellerID,
      required this.productID,
      required this.productName, this.data});

  @override
  _InnerChatScreenState createState() => _InnerChatScreenState();
}

class _InnerChatScreenState extends State<InnerChatScreen> {
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
        .where(
          'productID',
          isEqualTo: widget.productID,
        )
        .orderBy('timestamp', descending: true)
        .limit(60)
        .snapshots();
  }

  void _sendMessage() async {
    DocumentSnapshot sellerDoc =
        await _firestore.collection('vendors').doc(widget.sellerID).get();
    DocumentSnapshot buyerDoc =
        await _firestore.collection('buyers').doc(widget.buyerID).get();
    DocumentSnapshot productDoc =
        await _firestore.collection('products').doc(widget.productID).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'productID': widget.productID,
        'buyerName': (buyerDoc.data() as Map<String, dynamic>)['fullName'],
        'sellerName': (sellerDoc.data() as Map<String, dynamic>)['businessName'],
        'buyerPhoto': (buyerDoc.data() as Map<String, dynamic>)['userImage'],
        'sellerPhoto': (sellerDoc.data() as Map<String, dynamic>)['storeImage'],
        'buyerID': widget.buyerID,
        'sellerID': widget.sellerID,
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': DateTime.now(),
        'productName': (productDoc.data() as Map<String, dynamic>)['productName'],
      });
    }

    setState(() {
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _chatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('buyerID', isEqualTo: widget.buyerID)
        .where('sellerID', isEqualTo: widget.sellerID)
        .where('productID', isEqualTo: widget.productID)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Chat' + "> " + "" + widget.productName,
          style: TextStyle(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
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

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot document = snapshot.data!.docs[index];
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
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
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
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            !isBuyer
                                ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                              NetworkImage(data['sellerPhoto']),
                            )
                                : SizedBox(),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: isBuyer
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message,
                                    style: TextStyle(color: Colors.white),
                                    softWrap: true,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isBuyer
                                            ? buyerName
                                            : sellerName,
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      SizedBox(width: 4.0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.0),
                            isBuyer
                                ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                              NetworkImage(data['buyerPhoto']),
                            )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  });
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
                      hintText: 'Type a message...',
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
