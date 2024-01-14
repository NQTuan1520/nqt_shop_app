import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/views/screens/auth/welcome_screen/welcome_login_screen.dart';
import 'package:nqt_shop_app/views/screens/inner_screens/edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              'Hồ sơ',
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('buyers')
            .doc(_auth.currentUser!.uid)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Document does not exist'));
          }
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.yellow.shade900,
                    child: Image.network(
                      data['userImage'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_pin_outlined,
                      size: 20,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      data['fullName'],
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      size: 20,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      data['telephone'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
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
                      style: GoogleFonts.getFont(
                        'Roboto',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic>? updatedData =
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );

                    if (updatedData != null) {
                      setState(() {
                        // Update data from updatedData to the interface
                        data['fullName'] = updatedData['fullName'];
                        data['placeName'] = updatedData['placeName'];
                        data['telephone'] = updatedData['telephone'];
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
                SizedBox(height: 16),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Cài Đặt'),
                ),
                ListTile(
                  onTap: () async {
                    await _auth.signOut().whenComplete(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeLoginScreen(),
                        ),
                      );
                    });
                  },
                  leading: Icon(Icons.logout),
                  title: Text('Đăng Xuất'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
