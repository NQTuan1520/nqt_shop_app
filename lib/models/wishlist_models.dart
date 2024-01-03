import 'package:cloud_firestore/cloud_firestore.dart';

class WishListModels {
  final String productName;
  final String productID;
  final List imageUrl;
  final int quantity;
  final double price;
  final String vendorId;
  final String productSize;
  final Timestamp scheduleDate;
  final dynamic latitude;
  final dynamic longitude;
  final String businessName;
  final dynamic storeImage;
  final dynamic sizeList;
  final String category;
  final String description;

  WishListModels({
    required this.productName,
    required this.productID,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.vendorId,
    required this.productSize,
    required this.scheduleDate,
    required this.latitude,
    required this.longitude,
    required this.businessName,
    required this.storeImage,
    required this.sizeList,
    required this.category,
    required this.description,
  });

  factory WishListModels.fromMap(Map<String, dynamic> map) {
    return WishListModels(
      productName: map['productName'] ?? '',
      productID: map['productID'] ?? '',
      imageUrl: map['imageUrl'] ?? [],
      quantity: map['quantity'] ?? 0,
      price: map['productPrice'] ?? 0.0,
      vendorId: map['vendorId'] ?? '',
      productSize: map['productSize'] ?? '',
      scheduleDate: map['scheduleDate'] ?? Timestamp.now(),
      latitude: map['latitude'],
      longitude: map['longitude'],
      businessName: map['businessName'] ?? '',
      storeImage: map['storeImage'] ?? [],
      sizeList: map['sizeList'] ?? [],
      category: map['category'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productID': productID,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'productPrice': price,
      'vendorId': vendorId,
      'productSize': productSize,
      'scheduleDate': scheduleDate,
      'latitude': latitude,
      'longitude': longitude,
      'businessName': businessName,
      'storeImage': storeImage,
      'sizeList': sizeList,
      'category': category,
      'description': description,
    };
  }
}
