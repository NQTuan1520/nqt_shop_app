import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _placeNameController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load data from Firestore and display it in text fields
    loadUserData();
  }

  void loadUserData() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot userSnapshot = await _firestore.collection('buyers').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _fullNameController.text = userData['fullName'];
        _placeNameController.text = userData['placeName'];
        _telephoneController.text = userData['telephone'];
        _emailController.text = userData['email'];
        // Display data from Firestore on text fields for editing
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa hồ sơ'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Họ và tên'),
            ),
            TextFormField(
              controller: _placeNameController,
              decoration: InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextFormField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
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
              child: Text('Cập nhật hồ sơ'),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserProfile() async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('buyers').doc(userId).update({
      'fullName': _fullNameController.text,
      'placeName': _placeNameController.text,
      'telephone': _telephoneController.text,
      'email': _emailController.text,
    });
    Map<String, dynamic> updatedUserData = {
      'fullName': _fullNameController.text,
      'placeName': _placeNameController.text,
      'telephone': _telephoneController.text,
      'email': _emailController.text,
    };


    Navigator.of(context).pop(updatedUserData);
  }
}
