import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/vendor/views/screens/earnings_screen.dart';
import 'package:nqt_shop_app/vendor/views/screens/main_vendor_screen.dart';

import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class WithdrawalScreen extends StatelessWidget {
  late String amount;

  late String name;

  late String phoneNumber;

  late String bankName;
  late String bankAccountName;

  late String bankAccountNumber;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        title: Text(
          'Rút tiền ',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.white,
            letterSpacing: 2,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Hãy điền đủ thông tin';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tiền',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ' Họ và tên không được để trống';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Số điện thoại không được để trống';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tên tài khoản ngân hàng không được để trống';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Tên tài khoản ngân hàng, ví dụ: Vpbank, LPB,...',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Hãy điền đủ thông tin';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountName = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Tên tài khoản ngân hàng, ví dụ: Nguyen Quang Tuan,...',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Hãy điền đủ thông tin';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Số tài khoản ngân hàng',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      /// STORE DATE IN CLOUD FIRESTORE

                      await _firestore
                          .collection('withdrawal')
                          .doc(Uuid().v4())
                          .set({
                        'amount': amount,
                        'name': name,
                        'phoneNumber': phoneNumber,
                        'bankName': bankName,
                        'bankAccountName': bankAccountName,
                        'bankAccountNumber': bankAccountNumber,
                      });
                      print('good');
                    } else {
                      print('False');
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return MainVendorScreen();
                    }));
                  },
                  child: Text(
                    'Rút tiền',
                    style: GoogleFonts.getFont(
                      'Roboto',
                      fontSize: 18,
                    ),
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
