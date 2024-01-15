import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Function to store image in Firebase Storage

  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
    _storage.ref().child('storeImages').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> createVendor(
      String email,
      String password,
      ) async {
    String res = 'some error occured';

    try {
      //Create a new user in Firebase Auth,
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

//Function to store image in Firebase Storage ends here

  //Function to pick and store image
  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

  //Function to pick and store image ends here

// Function to save vendor data
  Future<String> registerVendor(
      String businessName,
      String email,
      String phoneNumber,
      String countryValue,
      String stateValue,
      String cityValue,
      Uint8List? image,
      ) async {
    String res = 'some error occured';

    try {
      String storeImage = await _uploadVendorImageToStorage(image);
      //Save data to Cloud Firestore

      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'businessName': businessName,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'storeImage': storeImage,
        'approved': false,
        'vendorId': _auth.currentUser!.uid,
      });

      ;
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

}
