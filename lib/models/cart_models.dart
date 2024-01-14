class CartModel {
  final String productName;
  final String productID;
  final List imageUrl;

  int quantity;


  final double price;

  final String vendorId;
  final String productSize;
  int shippingCharge;

  CartModel({
  required this.productName,
  required this.productID,
  required this.imageUrl,
  required this.quantity,
  required this.price,
  required this.vendorId,

  required this.productSize,
  required this.shippingCharge,
});
  Map<String, dynamic> toMap() {
    return {
      'productName': this.productName,
      'quantity': this.quantity,
    };
  }
}