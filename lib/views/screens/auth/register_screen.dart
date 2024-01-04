import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controller/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  Uint8List? _image;
  bool _isLoading = false;

  late String fullName;

  late String telephone;

  late String email;

  late String password;

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  registerUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await _authController.createUser(
      fullName,
      telephone,
      email,
      password,
      _image,
    );
    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Get.to(LoginScreen());
      Get.snackbar(
        'Success',
        'Congratulations Account has been Created For You',
        colorText: Colors.white,
        backgroundColor: Colors.pink,
        margin: EdgeInsets.all(15),
        icon: Icon(
          Icons.message,
          color: Colors.white,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } else {
      Get.snackbar(
        'Error Ocurred',
        res.toString(),
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(15),
        icon: Icon(
          Icons.message,
          color: Colors.white,
        ),
      );
    }
  }

  bool saveMe = false;

  void toggleSaveMe() {
    setState(() {
      saveMe = !saveMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 495;
    double screenWidth = MediaQuery.of(context).size.width;
    double fem = screenWidth / baseWidth;
    double ffem = fem * 0.97;
    double textSize = 17 * ffem;
    double textFieldFontSize = 16 * ffem;
    double buttonFontSize = 20 * ffem;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define different padding values based on screen height
    double bottomPadding;

    if (screenHeight < 592) {
      // For screens shorter than 592 logical pixels (approximately 6.7 inches)
      bottomPadding = screenHeight * 0.1; // Adjust this value as needed
    } else {
      // For larger screens, use a different padding
      bottomPadding = screenHeight * 0.20; // You can adjust this value too
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Container(
            padding:
            EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, bottomPadding),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/doorpng2.png'),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        25 * fem, 66 * fem, 19 * fem, 57.5 * fem),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              102 * fem, 0 * fem, 86.56 * fem, 78 * fem),
                          width: double.infinity,
                          child: Center(
                            child: SizedBox(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7 * fem),
                                  child: Stack(
                                    children: [
                                      _image != null
                                          ? CircleAvatar(
                                        backgroundImage:
                                        MemoryImage(_image!),
                                        radius: 65,
                                      )
                                          : CircleAvatar(
                                        radius: 65,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 70,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            selectGalleryImage();
                                          },
                                          icon: Icon(
                                            CupertinoIcons.photo,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 14 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 25 * fem),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 0 * fem, 5 * fem),
                                      child: Text(
                                        'Full Name',
                                        style: TextStyle(
                                          fontSize: textSize,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      onChanged: (value) {
                                        fullName = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your full name';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(9)),
                                        // focusedBorder: InputBorder.none,
                                        // enabledBorder: InputBorder.none,
                                        // errorBorder: InputBorder.none,
                                        // disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20 * fem,
                                            18 * fem,
                                            25.58 * fem,
                                            18 * fem),
                                        hintText: 'Input your full name',
                                        hintStyle:
                                        TextStyle(color: Color(0xffbcbcbc)),
                                      ),
                                      style: TextStyle(
                                        fontSize: textFieldFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Display error message
                            ],
                          ),
                        ),Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 14 * fem),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 25 * fem),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 0 * fem, 5 * fem),
                                      child: Text(
                                        'Telephone',
                                        style: TextStyle(
                                          fontSize: textSize,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        telephone = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your telephone';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(9)),
                                        // focusedBorder: InputBorder.none,
                                        // enabledBorder: InputBorder.none,
                                        // errorBorder: InputBorder.none,
                                        // disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20 * fem,
                                            18 * fem,
                                            25.58 * fem,
                                            18 * fem),
                                        hintText: 'Input your telephone',
                                        hintStyle:
                                        TextStyle(color: Color(0xffbcbcbc)),
                                      ),
                                      style: TextStyle(
                                        fontSize: textFieldFontSize,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Display error message
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 1 * fem, 11 * fem),
                          width: 450 * fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 5 * fem),
                                child: Text(
                                  'Email Address',
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email address';
                                  } else if (!value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      9,
                                    ),
                                  ),
                                  // focusedBorder: InputBorder.none,
                                  // enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(20 * fem,
                                      18 * fem, 25.58 * fem, 18 * fem),
                                  hintText: 'Input your email@gmail.com',
                                  hintStyle:
                                  TextStyle(color: Color(0xffbcbcbc)),
                                ),
                                style: TextStyle(
                                  fontSize: textFieldFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                ),
                              ),
                              // Display error message
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 1 * fem, 11 * fem),
                          width: 450 * fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 5 * fem),
                                child: Text(
                                  'Your password',
                                  style: TextStyle(
                                    fontSize: textSize,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              TextFormField(
                                obscureText: true,
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20 * fem, 18 * fem, 24.6 * fem, 18 * fem),
                                  hintText: 'Input your password',
                                  hintStyle:
                                  TextStyle(color: Color(0xffbcbcbc)),
                                ),
                                style: TextStyle(
                                  fontSize: textFieldFontSize,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                ),
                              ),
                              // Display error message
                            ],
                          ),
                        ),
                        SizedBox(height: 25,),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              3 * fem, 0 * fem, 4 * fem, 24 * fem),
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerUser();
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 60 * fem,
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(10 * fem),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SpinKitFadingCircle(
                                    color: Colors.pink,
                                    size: 50.0,
                                  ),
                                )
                                    : Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
