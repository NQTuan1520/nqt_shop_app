import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/wishlist_models.dart';

final favouriteProvider =
    StateNotifierProvider<FavouriteNotifier, Map<String, WishListModels>>(
  (ref) => FavouriteNotifier(),
);

class FavouriteNotifier extends StateNotifier<Map<String, WishListModels>> {
  FavouriteNotifier() : super({});

  void addProductToWish(
    String productName,
    String productID,
    List imageUrl,
    int quantity,
    double price,
    String vendorId,
    String productSize,
    Timestamp scheduleDate,
    dynamic latitude,
    dynamic longitude,
    String businessName,
    dynamic storeImage,
    dynamic sizeList,
    String category,
    String description,
  ) {
    if (state.containsKey(productID)) {
      state.remove(productID);
      print('Removed product from wishlist: $productID');
    } else {
      state[productID] = WishListModels(
        productName: productName,
        productID: productID,
        imageUrl: imageUrl,
        quantity: quantity,
        price: price,
        vendorId: vendorId,
        productSize: productSize,
        scheduleDate: scheduleDate,
        latitude: latitude,
        longitude: longitude,
        businessName: businessName,
        storeImage: storeImage,
        sizeList: sizeList,
        category: category,
        description: description,
      );
    }

    state = {...state};
  }

  void removeItem(String productID) {
    state.remove(productID);
    print('Removed product from wishlist: $productID');

    // Notify listeners that the state has changed
    state = {...state};
  }

  void removeAllItems() {
    state.clear();

    // Notify listeners that the state has changed
    state = {...state};
  }

  Map<String, WishListModels> get getwishItem => state;
}
