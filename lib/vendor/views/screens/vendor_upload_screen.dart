import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nqt_shop_app/vendor/views/screens/upload_tab_screens/attributes_tab_screens.dart';
import 'package:nqt_shop_app/vendor/views/screens/upload_tab_screens/general_tab_screen.dart';
import 'package:nqt_shop_app/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:nqt_shop_app/vendor/views/screens/upload_tab_screens/shipping_tab_screen.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/provider/app_data.dart';
import '../../../controller/provider/product_provider.dart';
import 'main_vendor_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  static const routeName = '/vendorUpload';

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);

    double? latitude = Provider.of<AppData>(context).pickUpAddress?.latitude;

    double? longitude = Provider.of<AppData>(context).pickUpAddress?.longitude;

    String? placeName = Provider.of<AppData>(context).pickUpAddress?.placeName;

    if (latitude == null && longitude == null && placeName == null) {
      latitude = null;
      longitude = null;
      placeName = null;
    }

    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.greenAccent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.production_quantity_limits),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Đăng tải sản phẩm',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            bottom: TabBar(tabs: [
              Tab(
                child: Text(
                  'Thông tin',
                  style: GoogleFonts.getFont(
                    'Roboto',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Phí vận chuyển',
                  style: GoogleFonts.getFont(
                    'Roboto',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Thuộc tính',
                  style: GoogleFonts.getFont(
                    'Roboto',
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Ảnh',
                  style: GoogleFonts.getFont(
                    'Roboto',
                  ),
                ),
              ),
            ]),
          ),
          body: TabBarView(children: [
            GeneralScreen(),
            ShippingScreeen(),
            AttributesTabScreen(),
            ImagesTabScreen(),
          ]),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
              ),
              onPressed: () async {
                DocumentSnapshot userDoc = await _firestore
                    .collection('vendors')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get();
                final productID = Uuid().v4();
                if (_formKey.currentState!.validate()) {
                  Fluttertoast.showToast(
                    msg: 'Vui lòng điền đủ các thông tin!',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  if (_productProvider.productData['imageUrl'] == null ||
                      _productProvider.productData['imageUrl'].isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Vui lòng thêm ít nhất một ảnh sản phẩm!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  } else if (_productProvider.productData['chargeShipping'] == null ||
                      _productProvider.productData['chargeShipping'].isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Vui lòng thêm Phí vận chuyển!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  } else if (_productProvider.productData['brandName'] == null ||
                      _productProvider.productData['brandName'].isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Vui lòng thêm Nhãn !',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }

                  EasyLoading.show(status: 'Uploading');
                  await _firestore.collection('products').doc(productID).set({
                    'latitude': latitude,
                    'longitude': longitude,
                    'placeName': placeName,
                    'businessName': (userDoc.data()
                        as Map<String, dynamic>)['businessName'],
                    'phoneNumber':
                        (userDoc.data() as Map<String, dynamic>)['phoneNumber'],
                    'countryValue': (userDoc.data()
                        as Map<String, dynamic>)['countryValue'],
                    'cityValue':
                        (userDoc.data() as Map<String, dynamic>)['cityValue'],
                    'stateValue':
                        (userDoc.data() as Map<String, dynamic>)['stateValue'],
                    'storeImage':
                        (userDoc.data() as Map<String, dynamic>)['storeImage'],
                    'productID': productID,
                    'productName': _productProvider.productData['productName'],
                    'bestseller': false,
                    'productPrice':
                        _productProvider.productData['productPrice'],
                    'quantity': _productProvider.productData['quantity'],
                    'category': _productProvider.productData['category'],
                    'description': _productProvider.productData['description'],
                    'imageUrl': _productProvider.productData['imageUrl'],
                    'scheduleDate':
                        _productProvider.productData['scheduleDate'],
                    'chargeShipping':
                        _productProvider.productData['chargeShipping'],
                    'shippingCharge':
                        _productProvider.productData['shippingCharge'],
                    'brandName': _productProvider.productData['brandName'],
                    'sizeList': _productProvider.productData['sizeList'],
                    'vendorId': FirebaseAuth.instance.currentUser!.uid,
                    'approved': false,
                  }).whenComplete(() {
                    EasyLoading.dismiss();
                    Fluttertoast.showToast(
                      msg:
                          'Đăng tải sản phẩm thành công, hãy chờ Quản trị viên phê duyệt!',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainVendorScreen();
                    }));
                    _productProvider.clearData();
                    _formKey.currentState!.reset();
                  });
                }
              },
              child: Text(
                'Đăng tải',
                style: GoogleFonts.getFont(
                  'Roboto',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
