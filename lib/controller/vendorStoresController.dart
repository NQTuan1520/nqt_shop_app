import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vendorModels.dart';

class VendorStoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<VendorModel> categories = <VendorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchVendorStores();
  }

  void _fetchVendorStores() {
    _firestore.collection('vendors').snapshots().listen((QuerySnapshot querySnapshot) {
      categories.assignAll(
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return VendorModel(
            vendorImage: data['storeImage'].toString(),
            vendorName: data['businessName'].toString(),
          );
        }).toList(),
      );
    });
  }
}
