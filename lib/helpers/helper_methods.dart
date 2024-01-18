import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../const/global_variable.dart';
import '../controller/provider/app_data.dart';
import '../models/address_models.dart';

import 'request_helper.dart';

class HelperMethods {
  static DateTime? lastApiCallTime;
  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    if (lastApiCallTime != null &&
        DateTime.now().difference(lastApiCallTime!) < Duration(minutes: 5)) {
      print('Skipped API call due to rate limit');
      return placeAddress;
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}';

    var response = await requestHelper.getRequest(url);
    print('Geocoding API Response: $response');
    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      AddressModels pickUpAddress = AddressModels();
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpAdress(pickUpAddress);

      lastApiCallTime = DateTime.now();
    }
    print('Address from findCordinateAddress: $placeAddress');

    return placeAddress;
  }

}
