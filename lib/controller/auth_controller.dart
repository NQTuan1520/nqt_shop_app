import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
//Uploading image and pick image

  _uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
    _storage.ref().child('profilePics').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

//Uploading image and pick image ends here

//Function to create new user
  Future<String> createUser(
      String fullName,
      String telephone,
      String email,
      String password,
      Uint8List? image,
      ) async {
    String res = 'some error occured';

    try {
      if (image != null) {
        //Create new user in Firebase Auth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profileImageUrl = await _uploadProfileImageToStorage(image);

        await _firestore.collection('buyers').doc(cred.user!.uid).set({
          'longitude': '',
          'latitude': '',
          'placeName': '',
          'fullName': fullName,
          'telephone': telephone,
          'email': email,
          'userImage': profileImageUrl,
          'buyerID': cred.user!.uid,
        });

        res = 'success';
      } else {
        res = 'please Fields must be field in';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // Function to create new user ends here

//Function to login user

  Future<String> loginUser(
      String email,
      String password,
      ) async {
    String res = 'some error occured';

    try {
      //Create new user in Firebase Auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
