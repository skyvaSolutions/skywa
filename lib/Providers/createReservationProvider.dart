import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/components/show_more_info_dailog.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/services/locationServices.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class createReservationProvider with ChangeNotifier {
  bool loading = false;
  Future<void> createReservation(BuildContext context, String date,
      String CompanyName, int index, Function() gotToCurrentScreen) async {
    var uuid = Uuid();
    String deviceId = userSettings.deviceID.value;
    String startTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());
    Location l = new Location();
    await l.getCurrentLocation();
    double lat = l.p.latitude;
    String resId = uuid.v1();
    double long = l.p.longitude;
    print("here2");
    print(date);
    Dio dio = new Dio();
    var data = {
      "DeviceID": deviceId,
      "MemberState": "Not Arrived",
      "ReservationID": resId,
      "ReservationStartTime": date,
      "Latitude": lat.toString(),
      "Longitude": long.toString(),
      "QID": nearbyQs[index].qid,
      // "QJoinTime": "notSet",
      // "OriginalETA": "notSet",
      // "LatestETA": "notSet",
      // "MemberQueuePosition": "notSet",
      "LastReportedLocationTimeStamp": startTime,
      // "LastReportedLocationAccuracy": "notSet",
      // "NoShowCount": "notSet",
      "MemberStateUpdateTimeStamp": startTime,
      //"WaitTime": 10,
      "ReservationType": "Vax",
      "PhoneNumber": "+1 242-302-4710",
      "NumberOfPeopleOnReservation": "1",
      // "ReservationCreatedTimeStamp": "notSet",
      "LocationName": CompanyName,
      // "Address": " 17 Blake Rd, Nassau, Bahamas",
      // "CompanyLogoURL": "DoctorsHospitalWest.jpg",
      // "QName": "Main Entrance",
      // "AuthorizedUsers": [],
      "AttendeeData": [],
      "CompanyName": CompanyName
    };
    print(data);
    print("Adding a Reservation");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Loading"),
            content: CircularProgressIndicator(),
          );
        });
    var response = await dio.post(
        "https://shoeboxtx.veloxe.com:36251/api/AddorUpdateReservationPost",
        data: data);
    Navigator.pop(context);
    print(response.data);
    getAndSortReservations();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            goToCurrentScreen: gotToCurrentScreen,
            companyName: CompanyName,
          );
        });
  }
}
