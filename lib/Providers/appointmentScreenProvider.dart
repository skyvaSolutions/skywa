import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/model/reservation.dart';
import 'package:skywa/screens/profileEditScreen.dart';

class appointmentScreenProvider with ChangeNotifier {
  List<Reservation> _upcomingReservation = [];
  List<Reservation> _pastReservation = [];
  List<Reservation> _activeReservation = [];
  List get pastRes => _pastReservation;
  List get upcomingRes => _upcomingReservation;
  List get activeRes => _activeReservation;

  Future<bool> getReservations() async {
    var id = userSettings.deviceID.value;
    _upcomingReservation = [];
    _pastReservation = [];
    _activeReservation = [];
    print(userSettings.deviceID.value);
    String url =
        "https://shoeboxtx.veloxe.com:36251/api/GetMyReservations?UserToken=${id}";
    Dio dio = new Dio();
    var data = await dio.get(url);
    print(data.data);
    List d = data.data;
    for (int i = 0; i < d.length; i++) {
      if (d[i]["MemberState"] != null || d[i]["MemberState"] != "notSet" && d[i]["ReservationStartTime"] != null && d[i]["ReservationStartTime"] != "notSet") {
        String memberState = d[i]["MemberState"];
        DateTime reservationStartTime = convertDateFromString(d[i]["ReservationStartTime"]);
        print(reservationStartTime);
        DateTime today = DateTime.now();
        print("started");
        if (memberState == "Completed" || (reservationStartTime.day < today.day || reservationStartTime.month < today.month || reservationStartTime.year < today.year))
          _pastReservation.add(Reservation.fromJson(d[i]));
        else if ((reservationStartTime.day > today.day || reservationStartTime.month > today.month || reservationStartTime.year > today.year))
          _upcomingReservation.add(Reservation.fromJson(d[i]));
        else
          _activeReservation.add(Reservation.fromJson(d[i]));


      }
    }
    return true;
  }
}
