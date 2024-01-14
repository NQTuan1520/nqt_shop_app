import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../controller/provider/product_provider.dart';

class GeneralScreen extends StatefulWidget {
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];

  _getCategories() {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      });
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');

    final outPutDate = outPutDateFormate.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Hãy điền tên sản phẩm!';
                } else {
                  return null;
                }
              }),
              onChanged: (value) {
                _productProvider.getFormData(productName: value);
              },
              decoration: InputDecoration(
                labelText: 'Điền tên sản phẩm',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Hãy điền giá sản phẩm!';
                } else {
                  return null;
                }
              }),
              onChanged: (value) {
                _productProvider.getFormData(productPrice: double.parse(value));
              },
              decoration: InputDecoration(
                labelText: 'Điền giá sản phẩm',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Hãy điền số lượng sản phẩm!';
                } else {
                  return null;
                }
              }),
              onChanged: (value) {
                _productProvider.getFormData(quantity: int.parse(value));
              },
              decoration: InputDecoration(
                labelText: 'Điền số lượng sản phẩm',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            DropdownButtonFormField(
                hint: Text('Hãy chọn danh mục sản phẩm'),
                items: _categoryList.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _productProvider.getFormData(category: value);
                  });
                }),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Hãy điền thông tin giới thiệu về sản phẩm!';
                } else {
                  return null;
                }
              }),
              onChanged: (value) {
                _productProvider.getFormData(description: value);
              },
              minLines: 3,
              maxLines: 10,
              maxLength: 800,
              decoration: InputDecoration(
                labelText: 'Điền thông tin giới thiệu về sản phẩm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(5000))
                        .then((value) {
                      setState(() {
                        _productProvider.getFormData(scheduleDate: value);
                      });
                    });
                  },
                  child: Text('Lịch đăng tải'),
                ),
                if (_productProvider.productData['scheduleDate'] != null)
                  Text(
                    formatedDate(
                      _productProvider.productData['scheduleDate'],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
