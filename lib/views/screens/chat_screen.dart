import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nqt_shop_app/views/screens/inner_screens/inner_chat_screen.dart';


class UserHomeChatScreen extends StatelessWidget {
  const UserHomeChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('chats')
        .where('buyerID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy('timestamp', descending: true)
    // Add orderBy clause
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              color: Colors.black,
            ),
            SizedBox(width: 10),
            Text(
              "Messages",
              style: TextStyle(
                color: Colors.black,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Messages',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            );
          }
          Map<String, QueryDocumentSnapshot> lastMessages = {};

          snapshot.data!.docs.forEach((doc) {
            String productID = doc['productID'].toString();
            String buyerID = doc['buyerID'].toString();

            String key = productID + '_' + buyerID;

            lastMessages.update(key, (existingDoc) {
              // Check if the current message's timestamp is newer
              if (existingDoc['timestamp'].toDate().isBefore(doc['timestamp'].toDate())) {
                return doc;
              }
              return existingDoc;
            }, ifAbsent: () => doc);
          });

          List<QueryDocumentSnapshot> lastMessagesList = lastMessages.values.toList();

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: lastMessagesList.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot document = lastMessagesList[index];
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              String message = data['message'].toString();
              String senderId = data['senderId'].toString();
              String productID = data['productID'].toString();
              String sellerID = data['sellerID'].toString();
              String productName = data['productName'].toString();

              bool isSellerMessage = senderId == FirebaseAuth.instance.currentUser!.uid;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InnerChatScreen(
                        sellerID: sellerID,
                        buyerID: FirebaseAuth.instance.currentUser!.uid,
                        productID: productID,
                        productName: productName,
                        data: data,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(data['buyerPhoto']),
                  ),
                  title: Text(message),
                  subtitle: isSellerMessage ? Text('Sent by Buyer') : Text('Sent by Seller'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}