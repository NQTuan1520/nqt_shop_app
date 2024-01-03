import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditVendorProfileScreen extends StatefulWidget {
  @override
  _EditVendorProfileScreenState createState() => _EditVendorProfileScreenState();
}

class _EditVendorProfileScreenState extends State<EditVendorProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data from Firestore and display it in text fields
    loadUserData();
  }

  void loadUserData() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot userSnapshot = await _firestore.collection('vendors').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _businessNameController.text = userData['businessName'];
        _phoneNumberController.text = userData['phoneNumber'];
        _emailController.text = userData['email'];
        // Display data from Firestore on text fields for editing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _businessNameController,
              decoration: InputDecoration(labelText: 'Business Name'),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update user information to Firebase
                updateUserProfile();
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserProfile() async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('vendors').doc(userId).update({
      'businessName': _businessNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'email': _emailController.text,
    });
    Map<String, dynamic> updatedUserData = {
      'businessName': _businessNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'email': _emailController.text,
    };


    Navigator.of(context).pop(updatedUserData);
  }
}
