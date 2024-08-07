import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/vendor/views/auth/vendor_login_screen.dart';

import '../../controllers/vendor_register_controller.dart';

class VendorRegisterScreen extends StatefulWidget {
  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  bool saveMe = false;

  void toggleSaveMe() {
    setState(() {
      saveMe = !saveMe;
    });
  }

  final VendorController _vendorController = VendorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  late String password;

  bool _isLoading = false;

  bool _showPassword = false;

  createUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String res = await _vendorController.createVendor(email, password);

      setState(() {
        _isLoading = false;
      });

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });

        Get.to(VendorLoginScreen());
        Get.snackbar(
          'Đăng ký thành công',
          'Tài khoản đã được tạo',
          backgroundColor: Colors.pink,
          colorText: Colors.white,
          messageText: Text(
            'Xin chúc mừng Tài khoản của bạn đã được tạo',
            style: GoogleFonts.getFont(
              'Roboto',
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        );
      } else {
        Get.snackbar(
          'Đã có lỗi xảy ra',
          res.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          messageText: Text(
            'Email đã được sử dụng',
            style: GoogleFonts.getFont(
              'Roboto',
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        );
      }
    }
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
    // Define different padding values based on screen height
    double bottomPadding;

    if (screenHeight < 6.8 * 10.0) {
      // For screens shorter than 6.8 inches, set bottomPadding to 10% of the screen height
      bottomPadding = screenHeight * 0.1; // Adjust this value as needed
    } else {
      // For larger screens, set bottomPadding to 0
      bottomPadding = 0;
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the app bar
      appBar: AppBar(
        elevation: 0, // Remove the app bar shadow
        backgroundColor: Colors.transparent, // Make the app bar transparent
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
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
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Form(
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
                                  70 * fem, 0 * fem, 86.56 * fem, 78 * fem),
                              width: double.infinity,
                              child: Center(
                                child: SizedBox(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(7 * fem),
                                    child: Image.asset(
                                      'assets/images/login-png-2-1-sGm.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
                                        0 * fem, 0 * fem, 0 * fem, 5 * fem),
                                    child: Text(
                                      'Email',
                                      style: GoogleFonts.getFont(
                                        'Roboto',
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
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Vui lòng nhập địa chỉ email';
                                      }
                                    },
                                    maxLines: null,
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
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20 * fem,
                                          18 * fem,
                                          25.58 * fem,
                                          18 * fem),
                                      hintText:
                                          'Nhập email của bạn(email@gmail.com)',
                                      hintStyle: GoogleFonts.getFont('Roboto',
                                          color: Color(0xffbcbcbc)),
                                    ),
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      fontSize: textFieldFontSize,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff000000),
                                    ),
                                  ),
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
                                      'Mật khẩu',
                                      style: GoogleFonts.getFont(
                                        'Roboto',
                                        fontSize: textSize,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      TextFormField(
                                        obscureText: !_showPassword,
                                        validator: (value) {
                                          if (value!.isNotEmpty) {
                                            return null;
                                          } else {
                                            return "Mật khẩu không được bỏ trống";
                                          }
                                        },
                                        onChanged: (value) {
                                          password = value;
                                        },
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                          ),
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20 * fem,
                                              18 * fem,
                                              48 * fem,
                                              18 * fem),
                                          hintText: 'Nhập mật khẩu của bạn',
                                          hintStyle: GoogleFonts.getFont(
                                              'Roboto',
                                              color: Color(0xffbcbcbc)),
                                        ),
                                        style: GoogleFonts.getFont(
                                          'Roboto',
                                          fontSize: textFieldFontSize,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                        icon: Icon(
                                          _showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Color(0xffbcbcbc),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  3 * fem, 0 * fem, 4 * fem, 24 * fem),
                              child: TextButton(
                                onPressed: () {
                                  createUser();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 60 * fem,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: SpinKitFadingCircle(
                                              color: Color(
                                                0xFFFF4081,
                                              ),
                                              size: 50.0,
                                            ),
                                          )
                                        : Text(
                                            'Đăng ký',
                                            style: GoogleFonts.getFont(
                                              'Roboto',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
