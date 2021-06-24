import 'dart:convert';
import 'package:skywa/services/locationServices.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:http/http.dart' as http;
import 'package:skywa/api_responses/recent_reservation.dart';
import 'dart:math' show cos, sqrt, asin;


QMetaData qMetaData = new QMetaData();
class QMetaData{

  double QLat;
  double QLong;
  Location location = new Location();

  Future<void> fingQMetaData() async {
    print("QMetaData api called");
    String deviceId = userSettings.deviceID.value;
    String reservationId = currentReservation.CurrentReservationId;
    String QId = currentReservation.QId;
    String url = "https://shoeboxtx.veloxe.com:36251/api/GetQMetadata?UserToken=95A5B76C-9B05-4992-A44D-DEA8E7AE094C644791499&QID=46181836-EC04-469E-8B2B-1E9F9565E5D0";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('QMetaData : Success');
      Map<String, dynamic> res = json.decode(response.body);
      print(res);
      print(res['Latitude']);
      print(res['Longitude']);
      QLat = double.parse(res['Latitude']);
      QLong = double.parse(res['Longitude']);
    }
    else {
      print('QMetaData : Error');
    }
    return null;
  }

  Future<double> calculateDistance() async {
    await fingQMetaData();
    await location.getCurrentLocation();
    double myLat = location.p.latitude;
    double myLong = location.p.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((QLat - myLat) * p)/2 +
        c(myLat * p) * c(QLat * p) *
            (1 - c((QLong - myLong) * p))/2;
    double distance =  12742 * asin(sqrt(a));
    print(distance);
    return distance;


  }
}