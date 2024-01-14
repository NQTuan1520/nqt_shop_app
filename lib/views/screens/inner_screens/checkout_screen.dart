import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nqt_shop_app/views/screens/cart_screen.dart';
import 'package:nqt_shop_app/views/screens/inner_screens/transaction_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/provider/cart_provider.dart';
import '../../../models/cart_models.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<Map<dynamic, dynamic>> selectedProducts;

  const CheckoutScreen({Key? key, required this.selectedProducts})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? paymentIntent = {};
  bool paymentCompleted = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? lastOrderID;

  TextEditingController _placeNameController = TextEditingController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // Handle payment cancellation if the app is inactive or paused
      _handlePaymentCancellation();
    }
  }

  Future<void> makePayment(double productPrice, String email, String name,
      BuildContext context) async {
    try {
      String customerId = await createStripeCustomer(email, name);
      paymentIntent = await createPaymentIntent(productPrice, customerId);

      var gpay = stripe.PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "US",
        testEnv: true,
      );

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          googlePay: gpay,
          merchantDisplayName: 'NQTuan',
        ),
      );
      displayPaymentSheet(context);
    } catch (e) {
      print('Error in makePayment(): $e');
      // Handle errors in makePayment()
      _showOrderSuccessDialog(context);
    }
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Đặt hàng thành công',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Cảm ơn bạn đã đặt hàng!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: Colors.grey,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/cart'),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void displayPaymentSheet(BuildContext context) async {
    paymentCompleted = false;
    try {
      await stripe.Stripe.instance.presentPaymentSheet();

      setState(() {
        paymentCompleted = true;
      });

      _updateFirestore(context);
    } on PlatformException catch (e) {
      if (e.code == 'payment_canceled') {
        _handlePaymentCancellation();
      } else {
        // Handle other errors
      }
    }
  }

  void _handlePaymentCancellation() {
    if (!paymentCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thanh toán bị hủy')),
      );
    }
  }

  void _updateFirestore(BuildContext context) async {
    try {
      // Get cart items and buyer data
      final cartItems = ref.read(cartProvider.notifier).getCartItems;
      final buyerData = await FirebaseFirestore.instance
          .collection('buyers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      await Future.forEach(cartItems.entries,
          (MapEntry<String, CartModel> entry) async {
        final item = entry.value;
        final orderId = Uuid().v4();

        await _firestore.collection('orders').doc(orderId).set({
          'orderID': orderId,
          'vendorId': item.vendorId,
          'email': buyerData['email'],
          'placeName': buyerData['placeName'],
          'buyerID': buyerData['buyerID'],
          'fullName': buyerData['fullName'],
          'telephone': buyerData['telephone'],
          'buyerPhoto': buyerData['userImage'],
          'productName': item.productName,
          'productPrice': item.quantity * item.price + item.shippingCharge,
          'productID': item.productID,
          'productImage': item.imageUrl,
          'quantity': item.quantity,
          'productSize': item.productSize,
          'orderDate': DateTime.now(),
          'accepted': false,
          'transferredToCarrier': false,
          'estimatedDeliveryDate': '',
          'receiveItem': false,
        });
        lastOrderID = orderId;
      });

      // Clear the cart after successful order placement
      ref.read(cartProvider.notifier).clearCart();

      // Dismiss any loading indicators
      EasyLoading.dismiss();

      // Display a success message
      showDialog(
        context: _scaffoldKey.currentState!.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Đặt hàng thành công'),
            content: Text('Cảm ơn bạn đã đặt hàng!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.popUntil(context, ModalRoute.withName('/cart'));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return TransactionScreen(orderID: lastOrderID);
                  }));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error updating Firestore: $error');

      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật dữ liệu')),
      );
    }
  }

  Future<String> createStripeCustomer(
    String email,
    String name,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        headers: {
          'Authorization':
              'Bearer sk_test_51ORSCpLQNw5BO6Nosjym3Qj5BrnZljMdPsVOUOjtfchmZxj0yWrpb7UqtVqlhCc7M7ABllIZLKE06E0dHmgJR3No00af02MfRb',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        final customerData = json.decode(response.body);
        return customerData['id']; // Return the customer ID
      } else {
        throw Exception('Failed to create customer: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    double amount,
    String customerEmail,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': (amount * 100).toInt().toString(), // Convert amount to cents
        'currency': "USD", // Use lowercase "usd"
        'customer': customerEmail, // Add customer email
        // Add customer name
      };

      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51ORSCpLQNw5BO6Nosjym3Qj5BrnZljMdPsVOUOjtfchmZxj0yWrpb7UqtVqlhCc7M7ABllIZLKE06E0dHmgJR3No00af02MfRb',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void initState() {
    super.initState();
    _loadPlaceName();
  }

  Future<void> _loadPlaceName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('buyers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String placeName = userData['placeName'];

      // Đặt giá trị cho TextEditingController
      _placeNameController.text = placeName;
    } catch (error) {
      print('Error loading placeName: $error');
    }
  }

  Future<void> _updatePlaceName(String newPlaceName) async {
    try {
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'placeName': newPlaceName});

      print('Updated placeName successfully');
    } catch (error) {
      print('Error updating placeName: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();

    final _cartProvider = ref.read(cartProvider.notifier);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          void _onStripePressed(BuildContext context) {
            try {
              makePayment(
                totalAmount,
                data['email'],
                data['fullName'],
                context,
              );
            } catch (e) {}
          }

          void _onCashOnDeliveryPressed(BuildContext context) {
            try {
              _updateFirestore(context);
            } catch (e) {}
          }

          void _showPaymentOptions(BuildContext context) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text(
                          'Thanh toán tại nhà',
                          style: GoogleFonts.getFont(
                            'Roboto',
                          ),
                        ),
                        onTap: () {
                          _onCashOnDeliveryPressed(context);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.credit_card),
                        title: Text(
                          'Thanh toán bằng thẻ tín dụng',
                          style: GoogleFonts.getFont(
                            'Roboto',
                          ),
                        ),
                        onTap: () {
                          _onStripePressed(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.greenAccent,
              title: Text(
                'Thanh Toán',
                style: GoogleFonts.getFont(
                  'Roboto',
                  fontSize: 25,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    controller: _placeNameController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ giao hàng',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String newPlaceName = _placeNameController.text;
                    _updatePlaceName(newPlaceName);
                  },
                  child: Text(
                    'Cập nhật địa chỉ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartProvider.getCartItems.length,
                    itemBuilder: (context, index) {
                      final cartData =
                          _cartProvider.getCartItems.values.toList()[index];
                      final product = widget.selectedProducts[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: SizedBox(
                            height: 170,
                            child: Row(children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(cartData.imageUrl[0]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartData.productName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(
                                      '\$' +
                                          " " +
                                          cartData.price.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.yellow.shade900,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (cartData.productSize != "")
                                          OutlinedButton(
                                            onPressed: null,
                                            child: Text(
                                              "Size: " + cartData.productSize,
                                            ),
                                          ),
                                        OutlinedButton(
                                          onPressed: null,
                                          child: Text(
                                            'Số lượng: ${product['quantity']}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Tổng số tiền thanh toán:' +
                      " " +
                      '\$' +
                      totalAmount.toStringAsFixed(2),
                  style: GoogleFonts.getFont(
                    'Roboto',
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        _showPaymentOptions(context);
                      },
                      child: Center(
                        child: Text(
                          'ĐẶT HÀNG',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            color: Colors.black,
                            letterSpacing: 4,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        );
      },
    );
  }
}
