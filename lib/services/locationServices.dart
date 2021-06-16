import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  Position p;
  String location;
  Future<bool> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print(permission);
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    var a = await Geolocator.getCurrentPosition();
    p = a;
    final coordinates = new Coordinates(a.latitude, a.longitude);

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(addresses.first.addressLine);
    location = addresses.first.addressLine;
    return true;
  }
}
