import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:http/http.dart' as http;
import 'package:skywa/api_responses/recent_reservation.dart';


DeleteReservation deleteReservation = new DeleteReservation();

class DeleteReservation {
  Future<void> deleteRes() async {
    print("DeleteReservation api called");
    String deviceId = userSettings.deviceID.value;
    String reservationId = currentReservation.CurrentReservationId;
    String url = "https://shoeboxtx.veloxe.com:36251/api/DeleteReservation?UserToken=$deviceId&ReservationID=$reservationId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('DeleteReservation : Success');
      print(response.body);
    }
    else {
      print('DeleteReservation : Error');
    }
    return null;
  }

}