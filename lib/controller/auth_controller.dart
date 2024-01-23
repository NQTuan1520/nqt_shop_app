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
    String res = 'some error occurred';

    try {
      // Check if the email address already exists in Authentication
      List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // If email address already exists, error message
      if (methods.isNotEmpty) {
        res = 'Email đã tồn tại. Xin vui lòng sử dụng một địa chỉ email khác.';
      } else {
        if (image != null) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

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
          res = 'Vui lòng điền đầy đủ thông tin';
        }
      }
    } catch (e) {
      // Custom error messages based on the error type
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            res = 'Địa chỉ email đã tồn tại. Vui lòng sử dụng địa chỉ email khác.';
            break;
          case 'invalid-email':
            res = 'Địa chỉ email không hợp lệ.';
            break;
        // Handle other error codes as needed
          default:
            res = 'Đã xảy ra lỗi: ${e.message}';
        }
      } else {
        res = 'Đã xảy ra lỗi: $e';
      }
    }

    return res;
  }



//Function to login user

  Future<String> loginUser(
    String email,
    String password,
  ) async {
    String res = 'some error occurred';

    try {
      //Create new user in Firebase Auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<String> forgotPassword(String email) async {
    String res = 'Some error occurred';

    try {
      if (!isValidEmail(email)) {
        res = 'Định dạng email không hợp lệ';
      } else {
        if (email.isNotEmpty) {
          await _auth.sendPasswordResetEmail(email: email);
          res = 'success';
          print('A reset link has been sent to your email');
        } else {
          res = 'Email không được để trống';
        }
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
