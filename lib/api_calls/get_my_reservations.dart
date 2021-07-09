import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/api_responses/reservations.dart';
import 'package:skywa/model/reservation.dart';


GetMyReservations getMyReservations = new GetMyReservations();

class GetMyReservations{


  Future<void> findReservations() async {
    myReservations.reservationsList = [];
    print("GetMyReservations api called");
    String deviceId = userSettings.deviceID.value;
    String url = "https://shoeboxtx.veloxe.com:36251/api/GetMyReservations?UserToken=$deviceId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('GetMyReservations : Success');
      List<dynamic> myResList = json.decode(response.body);
      print(myResList.length);
      if(myResList.length == 0){
        myReservations.noReservations = true;
        myReservations.reservationsLength = 0;
      }
      else{
        myReservations.noReservations = false;
        myReservations.reservationsLength = myResList.length;
        myResList.forEach((element) =>
          myReservations.reservationsList.add(Reservation.fromJson(element))
        );
      }
    }
    else{
      print('GetMyReservations : Error');
    }

    }

}
