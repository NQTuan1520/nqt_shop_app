import 'package:flutter/foundation.dart';

class AddressModels extends ChangeNotifier {
  String? placeName;
  double? latitude;

  double? longitude;

  String? placeId;
  String? placeFormattedAddress;

  AddressModels(
      {this.placeName,
      this.latitude,
      this.longitude,
      this.placeId,
      this.placeFormattedAddress});
}
