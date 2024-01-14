import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_products_tabs/published_tab.dart';
import 'edit_products_tabs/unpublished_tab.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('vendors');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return DefaultTabController(
            length: 1,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.orangeAccent,
                title: Row(
                  children: [
                    CircleAvatar(
                      minRadius: 25,
                      backgroundImage: NetworkImage(data['storeImage']),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Hi, Xin chào ' + data['businessName'],
                        style: GoogleFonts.getFont(
                          'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0,
                        ),
                      ),
                    )
                  ],
                ),
                bottom: TabBar(tabs: [
                  Tab(
                    child: Text('Sản phẩm'),
                  ),
                ]),
              ),
              body: TabBarView(children: [
                PublishedTab(),
              ]),
            ),
          );
        }
        return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade900,
            ));
      },
    );
  }
}
