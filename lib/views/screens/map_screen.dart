import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nqt_shop_app/views/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../../../helpers/helper_methods.dart';
import '../../controller/provider/app_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double bottomPadding = 0;
  late GoogleMapController mapController;
  final Geolocator geolocator = Geolocator();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  /// geting user location

  late Position currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    setUpPositionLocation();
  }

  setUpPositionLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      forceAndroidLocationManager: true,
    );

    _positionStreamSubscription = Geolocator.getPositionStream().listen(
          (Position position) {
        setState(() {
          currentPosition = position;
        });
        print('Current Position: $position');
      },
      onError: (error) {
        print('Error obtaining location: $error');
      },
    );

    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await HelperMethods.findCordinateAddress(position, context);

    print('Address from findCordinateAddress: $address');
    print('ok');
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.0136526, 105.8318255),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);

              mapController = controller;

              setState(() {
                bottomPadding = 300;
              });

              await setUpPositionLocation();
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 70,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final appData =
                              Provider.of<AppData>(context, listen: false);
                          if (appData.pickUpAddress != null) {
                            final latitude = appData.pickUpAddress!.latitude;
                            final longitude = appData.pickUpAddress!.longitude;
                            final placeName = appData.pickUpAddress!.placeName;

                            EasyLoading.show(status: 'Đang lưu vị trí...');
                            await FirebaseFirestore.instance
                                .collection('buyers')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              'latitude': latitude,
                              'longitude': longitude,
                              'placeName': placeName,
                            }).whenComplete(() {
                              EasyLoading.dismiss();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return MainScreen();
                              }));
                            });
                          } else {
                            print('pickupAddress is null');
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return MainScreen();
                            }));
                          }
                        },
                        icon: Icon(FontAwesomeIcons.shop),
                        label: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'CÙNG MUA SẮM NÀO',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
