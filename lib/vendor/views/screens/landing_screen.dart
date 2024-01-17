import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/vendor/views/auth/vendor_login_screen.dart';
import 'package:nqt_shop_app/vendor/views/screens/vendorMapScreen.dart';

import '../../models/vendor_user_models.dart';
import '../auth/vendor_registration_screen.dart';

class LandingScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final CollectionReference _vendorStream =
        FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _vendorStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.data!.exists) {
            return VendorRegistrationScreen();
          }

          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>);

          if (vendorUserModel.approved == true) {
            return VendorMapScreen();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    vendorUserModel.storeImage,
                    width: 90,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  vendorUserModel.businessName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Đăng ký của bạn đã được gửi tới Quản Trị Viên\nVui lòng đợi Quản Trị Viên duyệt tài khoản',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VendorLoginScreen();
                    }));
                  },
                  child: Text('Trờ lại màn hình đăng nhập'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
