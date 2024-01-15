import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/views/screens/auth/welcome_screen/welcome_login_screen.dart';

import '../../../../vendor/views/auth/vendor_register.dart';
import '../register_screen.dart';

class WelcomeRegisterScren extends StatelessWidget {
  const WelcomeRegisterScren({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -40,
              top: 0,
              child: Image.asset(
                'assets/images/doorpng2.png',
                width: screenWidth + 80,
                height: screenHeight + 100,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: screenWidth * 0.024,
              top: screenHeight * 0.06,
              child: Image.asset(
                'assets/images/login-png-2-1-sGm.png',
                width: screenWidth * 0.92,
                height: screenHeight * 0.7,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: screenWidth * 0.07,
              top: screenHeight * 0.641,
              child: InkWell(
                onTap: () {
                  Get.to(RegisterScreen());
                },
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.085,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    // Center the text vertically and horizontally
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng ký',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.black,
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Người Mua',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.red,
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.07,
              top: screenHeight * 0.77,
              child: InkWell(
                onTap: () {
                  Get.to(VendorRegisterScreen());
                },
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.085,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    // Center the text vertically and horizontally
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng ký',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.black,
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Người Bán',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.blue,
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.275,
              top: screenHeight * 0.88,
              child: SizedBox(
                width: screenWidth * 0.72,
                height: screenHeight * 0.033,
                child: InkWell(
                  onTap: () {
                    Get.to(() => WelcomeLoginScreen());
                  },
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: GoogleFonts.getFont(
                        'Roboto',
                        color: Colors.white,
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        const TextSpan(text: 'Đã có tài khoản?'),
                        const TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                        TextSpan(
                          text: 'Đăng nhập',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
