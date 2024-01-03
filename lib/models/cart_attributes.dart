class CartModel {
  final String productName;
  final String productID;
  final List imageUrl;

  int quantity;


  final double price;

  final String vendorId;
  final String productSize;

  CartModel({
  required this.productName,
  required this.productID,
  required this.imageUrl,
  required this.quantity,
  required this.price,
  required this.vendorId,
  required,
  required this.productSize,
});
}