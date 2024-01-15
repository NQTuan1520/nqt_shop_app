import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/categories_model.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }

  void _fetchCategories() {
    _firestore.collection('categories').limit(8).get().then((QuerySnapshot querySnapshot) {
      categories.assignAll(
        querySnapshot.docs.map((doc) => convertToCategoryModel(doc)).toList(),
      );
    });
  }

  CategoryModel convertToCategoryModel(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      categoryImage: data['image'].toString(),
      categoryName: data['categoryName'].toString(),
    );
  }
}

