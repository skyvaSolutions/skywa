import 'dart:convert';

import 'package:skywa/api_responses/recent_reservation.dart';
import 'package:skywa/model/reservation.dart';
import 'package:skywa/services/locationServices.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:http/http.dart' as http;


GetSingleReservation getSingleReservation = new GetSingleReservation();

class GetSingleReservation{
  Future<void> getCurrentReservation() async {
    String deviceId = userSettings.deviceID.value;
    String reservationId = currentReservation.CurrentReservationId;
    Location l = new Location();
    await l.getCurrentLocation();
    double lat = l.p.latitude;
    double long = l.p.longitude;
    print("GetSingleReservation api called");
    String url =
        "https://shoeboxtx.veloxe.com:36251/api/getSingleReservation?UserToken=95A5B76C-9B05-4992-A44D-DEA8E7AE094C644791499&ReservationID=7DEA4D46-C9B6-429D-BBF7-6F4635F1DAED&Latitude=30.5&Longitude=-97.8";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('GetSingleReservation : Success');
      Map<String, dynamic> res = json.decode(response.body);
      print(res);
      currentReservation.currentRes = Reservation.fromJson(res);
      //print(currentReservation.currentRes.CompanyName);
    }
    else {
      print('GetSingleReservation : Error');
    }
  }
}


//"https://shoeboxtx.veloxe.com:36251/api/getSingleReservation?UserToken=95A5B76C-9B05-4992-A44D-DEA8E7AE094C644791499&ReservationID=7DEA4D46-C9B6-429D-BBF7-6F4635F1DAED&Latitude=30.5&Longitude=-97.8";
//"https://shoeboxtx.veloxe.com:36251/api/getSingleReservation?UserToken=$deviceId&ReservationID=$reservationId&Latitude=$lat.5&Longitude=$long";