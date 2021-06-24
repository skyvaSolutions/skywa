import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/api_responses/reservations.dart';
import 'package:skywa/model/reservation.dart';


GetMyReservations getMyReservations = new GetMyReservations();

class GetMyReservations{


  void findReservations() async {
    print("GetMyReservations api called");
    String deviceId = userSettings.deviceID.value;
    String url = "https://shoeboxtx.veloxe.com:36251/api/GetMyReservations?UserToken=95A5B76C-9B05-4992-A44D-DEA8E7AE094C644791499";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('GetMyReservations : Success');
      List<dynamic> myResList = json.decode(response.body);
      print(myResList.length);
      if(myResList.length == 0){
        myReservations.noReservations = true;
      }
      else{
        myReservations.noReservations = false;
        myResList.forEach((element) =>
          myReservations.reservationsList.add(Reservation.fromJson(element))
        );
      }
        print(myReservations.reservationsList);
        print(myReservations.noReservations);
    }
    else{
      print('GetMyReservations : Error');
    }

    }

}
