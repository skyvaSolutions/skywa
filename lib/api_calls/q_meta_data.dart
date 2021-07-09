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
  double parkingLotDistance;
  bool isDataSet = false;

  Future<void> fingQMetaData() async {
    print("QMetaData api called");
    String deviceId = userSettings.deviceID.value;
    String QId = currentReservation.QId;
    print(QId);
    String url = "https://shoeboxtx.veloxe.com:36251/api/GetQMetadata?UserToken=$deviceId&QID=$QId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('QMetaData : Success');
      Map<String, dynamic> res = json.decode(response.body);
      print(res);
      print(res['Latitude']);
      print(res['Longitude']);
      if(res['Latitude'] != "notSet"){
        QLat = double.parse(res['Latitude']);
        isDataSet = true;
      }
      else{
        isDataSet = false;
      }
      if(res['Longitude'] != "notSet"){
        QLong = double.parse(res['Longitude']);
        isDataSet = true;
      }
      else{
        isDataSet = false;
      }
      if(res['ParkingLotDistance'] != "notSet"){
        parkingLotDistance = double.parse(res['ParkingLotDistance']);
        isDataSet = true;
      }
      else{
        isDataSet = false;
      }
    }
    else {
      print('QMetaData : Error');
    }
    return null;
  }

  Future<double> calculateDistance() async {
    await fingQMetaData();
    await location.getCurrentLocation();
    if(isDataSet){
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
    else{
      return -1;
    }


  }
}