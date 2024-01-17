import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/productDetailModel.dart';

class FashionProductsWidget extends StatefulWidget {
  @override
  _FashionProductsWidgetState createState() => _FashionProductsWidgetState();
}

class _FashionProductsWidgetState extends State<FashionProductsWidget> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _currentPage = 0;
  late Stream<QuerySnapshot> _productsStream;
  late AsyncSnapshot<QuerySnapshot> _snapshot;

  @override
  void initState() {
    super.initState();
    _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', whereIn: ['Thời trang', 'Giày'])
        .where('approved', isEqualTo: true)
        .snapshots();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _snapshot.data!.docs.length - 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _scrollController.animateTo(
        _currentPage * 180,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LinearProgressIndicator(
              color: Colors.pink.shade900,
            ),
          );
        }

        // _snapshot = snapshot; // Assign the snapshot to the class-level variable

        return Container(
          height: 250,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              return ProductDetailModel(
                productData: productData,
                fem: fem,
              );
            },
          ),
        );
      },
    );
  }
}
