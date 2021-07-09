import 'dart:convert';

import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:dio/dio.dart';

List<NearbyQsModel> nearbyLocationsFromJson(String str) =>
    List<NearbyQsModel>.from(
        json.decode(str).map((x) => NearbyQsModel.fromJson(x)));

class NearbyQsModel {
  NearbyQsModel({
    this.qid,
    this.companyName,
    this.locationName,
    this.address,
    this.latitude,
    this.longitude,
    this.distance,
    this.logoUrl,
    this.qWaitTime,
    this.status,
    this.qName,
    this.qLength,
    this.locationId,
    this.qMode,
    this.trainingCode,
    this.openTime,
    this.closeTime,
    this.maxReservationDistance,
    this.earliestAvailableReservation,
  });

  String qid;
  String companyName;
  String locationName;
  String address;
  String latitude;
  String longitude;
  String distance;
  String logoUrl;
  String qWaitTime;
  String status;
  String qName;
  String qLength;
  String locationId;
  String qMode;
  String trainingCode;
  String openTime;
  String closeTime;
  String maxReservationDistance;
  DateTime earliestAvailableReservation;

  factory NearbyQsModel.fromRawJson(String str) =>
      NearbyQsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearbyQsModel.fromJson(Map<String, dynamic> json) => NearbyQsModel(
        qid: json["QID"],
        companyName: json["CompanyName"],
        locationName: json["LocationName"],
        address: json["Address"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        distance: json["Distance"],
        logoUrl: json["LogoURL"],
        qWaitTime: json["QWaitTime"],
        status: json["Status"],
        qName: json["QName"],
        qLength: json["QLength"],
        locationId: json["LocationID"],
        qMode: json["QMode"],
        trainingCode: json["TrainingCode"],
        openTime: json["OpenTime"],
        closeTime: json["CloseTime"],
        maxReservationDistance: json["MaxReservationDistance"],
        earliestAvailableReservation:DateTime.parse(json["EarliestAvailableReservation"]),
      );

  Map<String, dynamic> toJson() => {
        "QID": qid,
        "CompanyName": companyName,
        "LocationName": locationName,
        "Address": address,
        "Latitude": latitude,
        "Longitude": longitude,
        "Distance": distance,
        "LogoURL": logoUrl,
        "QWaitTime": qWaitTime,
        "Status": status,
        "QName": qName,
        "QLength": qLength,
        "LocationID": locationId,
        "QMode": qMode,
        "TrainingCode": trainingCode,
        "OpenTime": openTime,
        "CloseTime": closeTime,
        "MaxReservationDistance": maxReservationDistance,
        "EarliestAvailableReservation":
            earliestAvailableReservation.toIso8601String(),
      };
}

class GetNearbyQService {
  static String funcName = 'Get Nearby Qs ';

  //https://shoeboxtx.veloxe.com:36251/api/GetNearbyQueues?UserToken=F870F7FB-63A1-458A-9B8C-1D10D13ACA6B635119728&Latitude=30.5&Longitude=-97.8

  Future<bool> getNearbyQueues() async {
    //TODO take out hard coded lat long
    gLatitude = '30.5';
    gLongitude = '-97.8';
    print("About to call version services");
    try {
      Response response =
          await dio.get(apiURL + 'getNearbyQueues', queryParameters: {
        'UserToken': userSettings.deviceID.value,
        'Latitude': gLatitude,
        'Longitude': gLongitude,
      });

      // Map nearbyLocationsMap = response.data;
      print("$funcName response found");
      print(response.data);
      nearbyQs = (response.data as List)
          .cast<Map<String, dynamic>>()
          .map((e) => NearbyQsModel.fromJson(e))
          .toList();
      //nearbyQs = NearbyQsModel.fromJson(response.data);

      print("$funcName Map complete");

      return (true);
    } catch (e) {
      print("$funcName Error found");
      print(e);
      return (false);
    }
  }
}
