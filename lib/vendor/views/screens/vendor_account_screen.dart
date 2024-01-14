import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/vendor/views/screens/vendor_inner_screen/edit_vendor_profile_screen.dart';
import 'package:nqt_shop_app/views/screens/auth/welcome_screen/welcome_login_screen.dart';

class VendorAccountScreen extends StatefulWidget {
  @override
  State<VendorAccountScreen> createState() => _VendorAccountScreenState();
}

class _VendorAccountScreenState extends State<VendorAccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsetsDirectional.only(end: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Colors.black,
              ),
              SizedBox(width: 5),
              Text(
                'Hồ sơ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.yellow.shade900,
                      backgroundImage: NetworkImage(data['storeImage']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_pin_outlined,
                          size: 20,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          data['businessName'],
                          style: TextStyle(
                            fontSize: 17,
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
                          Icons.phone_in_talk,
                          size: 20,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          data['phoneNumber'],
                          style: TextStyle(
                            fontSize: 17,
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
                          Icons.email,
                          size: 20,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          data['email'],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic>? updatedData =
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditVendorProfileScreen(),
                        ),
                      );

                      if (updatedData != null) {
                        setState(() {
                          // Update data from updatedData to the interface
                          data['businessName'] = updatedData['businessName'];
                          data['phoneNumber'] = updatedData['phoneNumber'];
                          data['email'] = updatedData['email'];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 5,
                      shadowColor: Colors.grey,
                    ),
                    child: Text(
                      'Chỉnh sửa hồ sơ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Cài đặt', style: GoogleFonts.getFont(
                      'Roboto',),),
                  ),
                  ListTile(
                    onTap: () async {
                      await _auth.signOut().whenComplete(() {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return WelcomeLoginScreen();
                            }));
                      });
                    },
                    leading: Icon(Icons.logout),
                    title: Text('Đăng xuất', style: GoogleFonts.getFont(
                      'Roboto',),),
                  ),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

