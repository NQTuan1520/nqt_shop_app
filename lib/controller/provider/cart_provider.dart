import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cart_models.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  Future<int> getAvailableQuantityFromFirebase(String productID) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productID)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('quantity')) {
          return data['quantity'] ?? 0;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting quantity: $e');
      return 0;
    }
  }

  void addProductToCart(
    String productName,
    String productID,
    List imageUrl,
    int quantity,
    double price,
    String vendorId,
    String productSize,
    int shippingCharge,
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
          shippingCharge: state[productID]!.shippingCharge,
        )
      };
    } else {
      state = {
        ...state,
        productID: CartModel(
          productName: productName,
          productID: productID,
          imageUrl: imageUrl,
          quantity: 1,
          price: price,
          vendorId: vendorId,
          productSize: productSize,
          shippingCharge: shippingCharge,
        )
      };
    }
  }

  void incrementItem(String productID) async {
    if (state.containsKey(productID)) {
      int currentQuantity = state[productID]!.quantity;

      int availableQuantity = await getAvailableQuantityFromFirebase(productID);

      if (currentQuantity < availableQuantity) {
        state[productID]!.quantity++;
        state = {...state};
      } else {
        print('Số lượng vượt quá tồn kho.');
      }
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
      totalAmount +=
          cartItem.quantity * cartItem.price + cartItem.shippingCharge;
    });

    return totalAmount;
  }

  void clearCart() {
    state = {}; // Clear the cart items
  }

  Map<String, CartModel> get getCartItems => state;
}
