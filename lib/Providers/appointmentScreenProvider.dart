import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/model/reservation.dart';

class appointmentScreenProvider with ChangeNotifier {
  List<Reservation> _upcomingReservation = [];
  List<Reservation> _pastReservation = [];
  List<Reservation> _activeReservation = [];
  List get pastRes => _pastReservation;
  List get upcomingRes => _upcomingReservation;
  List get activeRes => _activeReservation;

  void getReservations() async {
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
      if (d[i]["ReservationStartTime"] != null) {
        var parsedDate = DateTime.parse(d[i]["ReservationStartTime"]);
        print("started");
        print(DateTime.now().toUtc().toString() +
            " minus " +
            parsedDate.toString() +
            " " +
            parsedDate.difference(DateTime.now().toUtc()).inHours.toString());
        if (parsedDate.difference(DateTime.now().toUtc()).inHours <= 5 &&
            parsedDate.difference(DateTime.now().toUtc()).inHours >= 0) {
          print("yes");
          _activeReservation.add(Reservation.fromJson(d[i]));
        } else if (parsedDate.difference(DateTime.now().toUtc()).inHours < 0) {
          _pastReservation.add(Reservation.fromJson(d[i]));
        } else {
          _upcomingReservation.add(Reservation.fromJson(d[i]));
        }
      }
    }
  }
}