import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    String res =
        await AuthController.instance.forgotPassword(_emailController.text);

    setState(() {
      _isLoading = false;
      _emailController.clear();
      _errorText = res != 'success' ? res : null;
    });

    if (res == 'success') {
      Get.snackbar(
        'Mật khẩu đã được gửi tới Email của bạn',
        'Hãy kiểm tra nó!',
        backgroundColor: Colors.pink,
        colorText: Colors.white,
      );
      Navigator.pop(context);
    } else {
      Get.snackbar(
        'Đã có lỗi xảy ra',
        res.toString(),
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        // Other app bar properties...
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/doorpng2.png'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quên Mật Khẩu',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.key),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Cung cấp email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu của bạn',
              style: GoogleFonts.getFont(
                'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Nhập email',
                hintStyle: GoogleFonts.getFont('Roboto'),
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
                errorText: _errorText,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _resetPassword,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Gửi mật khẩu tới Email',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
