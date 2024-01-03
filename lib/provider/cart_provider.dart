import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_attributes.dart';

final cartProvider =
StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductToCart(
      String productName,
      String productID,
      List imageUrl,
      int quantity,
      double price,
      String vendorId,
      String productSize,
      ) {
    if (state.containsKey(productID)) {
      state = {
        ...state,
        productID: CartModel(
          productName: state[productID]!.productName,
          productID: state[productID]!.productID,
          imageUrl: state[productID]!.imageUrl,
          quantity: state[productID]!.quantity + 1,
          price: state[productID]!.price,
          vendorId: state[productID]!.vendorId,
          productSize: state[productID]!.productSize,
        )
      };
    } else {
      state = {
        ...state,
        productID: CartModel(
          productName: productName,
          productID: productID,
          imageUrl: imageUrl,
          quantity: quantity,
          price: price,
          vendorId: vendorId,
          productSize: productSize,
        )
      };
    }
  }

  void incrementItem(String productID) {
    if (state.containsKey(productID)) {
      state[productID]!.quantity++;

      ///notify listeners that the state has changed
      ///
      state = {...state};
    }
  }

  void decrementItem(String productID) {
    if (state.containsKey(productID)) {
      state[productID]!.quantity--;

      ///notify listeners that the state has changed
      ///
      state = {...state};
    }
  }

  void removeItem(String productID) {
    state.remove(productID);

    state = {...state};
  }

  void removeAllItem() {
    state.clear();

    state = {...state};
  }


  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productID, cartItem) {
      totalAmount += cartItem.quantity * cartItem.price;
    });

    return totalAmount;
  }


  Map<String, CartModel> get getCartItems => state;
}