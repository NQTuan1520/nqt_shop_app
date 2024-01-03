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
              top: screenHeight * 0.151,
              child: Image.asset(
                'assets/images/Illustration.png',
                width: screenWidth * 0.92,
                height: screenHeight * 0.523,
                fit: BoxFit.cover,
              ),
            ),
            // Positioned(
            //   left: screenWidth * 0.178,
            //   top: screenHeight * 0.065,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(7),
            //     clipBehavior: Clip.hardEdge,
            //     child: Image.network(
            //       '',
            //       width: screenWidth * 0.65,
            //       height: screenHeight * 0.197,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
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
                    child: Text(
                      'Register As Buyer',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontSize: screenHeight * 0.022,
                        fontWeight: FontWeight.w500,
                      ),
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
                    child: Text(
                      'Register As Seller',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.black,
                        fontSize: screenHeight * 0.022,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.2,
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
                        'Poppins',
                        color: Colors.white,
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account?'),
                        const TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: Color(0xFF1B1B1B),
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.getFont(
                            'Poppins',
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
