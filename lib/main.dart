import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get/get.dart';
import 'package:nqt_shop_app/provider/app_data.dart';
import 'package:nqt_shop_app/provider/product_provider.dart';
import 'package:nqt_shop_app/vendor/controllers/banner_controller.dart';
import 'package:nqt_shop_app/vendor/controllers/vendorStoresController.dart';
import 'package:nqt_shop_app/views/screens/auth/welcome_screen/welcome_register_screen.dart';
import 'package:nqt_shop_app/views/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'controller/auth_controller.dart';
import 'controller/category_controller.dart';

void main() async {
  // Ensure that Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      // Initialize Firebase.
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAYnoKXoQaY7Rp-RGHEFfmy0Rva8xk-Fec",
              appId: "1:851800943545:android:ed13069ac3e6b8f1cbe468",
              messagingSenderId: "851800943545",
              projectId: "store-e82c3",
              storageBucket: "gs://store-e82c3.appspot.com"),
        ).then((value) {
          Get.put(AuthController());

          Stripe.publishableKey =
              "pk_test_51ORSCpLQNw5BO6No2ftz9HzVYPB1PMm9ZDXwXSo9HSPqSqXS4sfUdK348V1Jl71vwkynxTuHl5spKfbs9sn97NnC00XjJy04FZ";
        })
      : await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAYnoKXoQaY7Rp-RGHEFfmy0Rva8xk-Fec",
              appId: "1:851800943545:ios:eeb5ca333b89158bcbe468",
              messagingSenderId: "851800943545",
              projectId: "store-e82c3",
              storageBucket: "gs://store-e82c3.appspot.com"),
        ).then((value) {
          Get.put(AuthController());

          Stripe.publishableKey =
              "pk_test_51ORSCpLQNw5BO6No2ftz9HzVYPB1PMm9ZDXwXSo9HSPqSqXS4sfUdK348V1Jl71vwkynxTuHl5spKfbs9sn97NnC00XjJy04FZ";
        });

  // Wrap app with ProviderScope to use Riverpod for state management.
  runApp(
    riverpod.ProviderScope(
      child: MultiProvider(providers: [
        ChangeNotifierProvider(create: (
          _,
        ) {
          return AppData();
        }),
        ChangeNotifierProvider(create: (
          _,
        ) {
          return ProductProvider();
        })
      ], child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: WelcomeRegisterScren(),
      builder: EasyLoading.init(),
      initialBinding: BindingsBuilder(
        () {
          Get.put<VendorStoreController>(VendorStoreController());
          Get.put<CategoryController>(CategoryController());
          Get.put<BannerController>(BannerController());
        },
      ),
    );
  }
}
