import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/provider/cart_provider.dart';
import 'inner_screens/checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.greenAccent,
        automaticallyImplyLeading: true,
        title: Padding(
          padding: EdgeInsetsDirectional.only(start: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.shopping_cart, // Biểu tượng giỏ hàng
                color: Colors.brown,
              ),
              SizedBox(width: 10), // Khoảng cách giữa biểu tượng và tiêu đề
              Text(
                'Giỏ hàng',
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartProvider.removeAllItem();
            },
            icon: Icon(
              CupertinoIcons.delete,
            ),
          ),
        ],
      ),
      body: cartData.isNotEmpty
          ? Column(
            children: [
              Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  final cartItem = cartData.values.toList()[index];
                
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: SizedBox(
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                cartItem.imageUrl[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.productName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "\$" + " "+ cartItem.price.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow.shade900,
                                    ),
                                  ),
                                  Text(
                                    "Phí giao hàng" + " \$" + cartItem.shippingCharge.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (cartItem.quantity > 1) {
                                                  _cartProvider.decrementItem(cartItem.productID);
                                                }
                                              },
                                              icon: Icon(
                                                CupertinoIcons.minus,
                                                color: cartItem.quantity > 1 ? Colors.black : Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              cartItem.quantity.toString(),
                                              style:
                                              TextStyle(color: Colors.black),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _cartProvider.incrementItem(
                                                    cartItem.productID);
                                              },
                                              icon: Icon(
                                                CupertinoIcons.plus,
                                                color: cartItem.quantity >= 1 ? Colors.black : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _cartProvider
                                              .removeItem(cartItem.productID);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.delete,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              totalAmount == 0.0
                  ? SizedBox()
                  : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(selectedProducts: cartData.values.map((item) => item.toMap()).toList()),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(
                              9,
                            )),
                        child: Center(
                          child: Text(
                            'THANH TOÁN' +
                                " " +
                                '\$' +
                                totalAmount.toStringAsFixed(2),
                            style: GoogleFonts.getFont(
                              'Roboto',
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Giỏ hàng của bạn đang trống',
              style: GoogleFonts.getFont(
                'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              "Bạn chưa thêm bất kỳ sản phẩm nào vào giỏ hàng của mình. \nBạn có thể thêm chúng từ màn hình chính",
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
