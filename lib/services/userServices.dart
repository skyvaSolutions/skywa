import 'dart:convert';

import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:dio/dio.dart';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));
String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.phoneNumber,
    this.email,
    this.subscribed,
    this.deviceId,
    this.userType,
    this.subscribedTimeStamp,
//    this.createdTimeStamp,
    this.userName,
    this.numberOfLogins,
//    this.numberOfAds,
//    this.numberOfAdRows,
    this.logInPromotionStart,
    this.receiptPromotionStart,
//    this.dateofLastLogin,
//    this.dateofLastMessage,
//    this.trialExpireDate,
    this.installedVersion,
//    this.verificationTimeStampArray,
    this.authorizedLocationId,
    this.authorizationStatus,
    this.showMeDemoQueues,
    //   this.id,
    //  this.deviceIdArray,
    //   this.v,
    //  this.numberOfLinkedDevices,
  });

  String phoneNumber;
  String email;
  String subscribed;
  String deviceId;
  String userType;
  String subscribedTimeStamp;
//  DateTime createdTimeStamp;
  String userName;
  String numberOfLogins;
//  String numberOfAds;
//  String numberOfAdRows;
  String logInPromotionStart;
  String receiptPromotionStart;
//  DateTime dateofLastLogin;
//  DateTime dateofLastMessage;
//  DateTime trialExpireDate;
  String installedVersion;
  // List<String> verificationTimeStampArray;
  String authorizedLocationId;
  String authorizationStatus;
  String showMeDemoQueues;
  // String id;
  // List<String> deviceIdArray;
  // String v;
  // int numberOfLinkedDevices;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        phoneNumber: json["PhoneNumber"],
        email: json["Email"],
        subscribed: json["Subscribed"],
        deviceId: json["DeviceID"],
        userType: json["UserType"],
        subscribedTimeStamp: json["SubscribedTimeStamp"],
        //      createdTimeStamp: DateTime.parse(json["CreatedTimeStamp"]),
        userName: json["UserName"],
        numberOfLogins: json["NumberOfLogins"],
//        numberOfAds: json["NumberOfAds"],
//        numberOfAdRows: json["NumberOfAdRows"],
        logInPromotionStart: json["LogInPromotionStart"],
        receiptPromotionStart: json["ReceiptPromotionStart"],
//        dateofLastLogin: DateTime.parse(json["DateofLastLogin"]),
//        dateofLastMessage: DateTime.parse(json["DateofLastMessage"]),
//        trialExpireDate: DateTime.parse(json["TrialExpireDate"]),
        installedVersion: json["InstalledVersion"],
        //     verificationTimeStampArray:

        // json["VerificationTimeStampArray"].map((x) => x)),
        //       verificationTimeStampArray:
        //         List<String>.from(json["DeviceIDArray"].map((x) => x)),
        authorizedLocationId: json["AuthorizedLocationID"],
        authorizationStatus: json["AuthorizationStatus"],
        showMeDemoQueues: json["ShowMeDemoQueues"],
        //      id: json["_id"],
        //     deviceIdArray: List<String>.from(json["DeviceIDArray"].map((x) => x)),

//        v: json["__v"],
        //    numberOfLinkedDevices: json["numberOfLinkedDevices"],
      );

  Map<String, dynamic> toJson() => {
        "PhoneNumber": phoneNumber,
        "Email": email,
        "Subscribed": subscribed,
        "DeviceID": deviceId,
        "UserType": userType,
        "SubscribedTimeStamp": subscribedTimeStamp,
//        "CreatedTimeStamp": createdTimeStamp.toIso8601String(),
        "UserName": userName,
        "NumberOfLogins": numberOfLogins,
//        "NumberOfAds": numberOfAds,
//        "NumberOfAdRows": numberOfAdRows,
        "LogInPromotionStart": logInPromotionStart,
        "ReceiptPromotionStart": receiptPromotionStart,
//        "DateofLastLogin": dateofLastLogin.toIso8601String(),
//        "DateofLastMessage": dateofLastMessage.toIso8601String(),
//        "TrialExpireDate": trialExpireDate.toIso8601String(),
        "InstalledVersion": installedVersion,
        //     "VerificationTimeStampArray":
        //       "VerificationTimeStampArray":
        //       List<dynamic>.from(deviceIdArray.map((x) => x)),
        //           List<dynamic>.from(verificationTimeStampArray.map((x) => x)),
        "AuthorizedLocationID": authorizedLocationId,
        "AuthorizationStatus": authorizationStatus,
        "ShowMeDemoQueues": showMeDemoQueues,
        //      "_id": id,
        //      "DeviceIDArray": List<dynamic>.from(deviceIdArray.map((x) => x)),
//        "__v": v,
        //       "numberOfLinkedDevices": numberOfLinkedDevices,
      };
}

class UserService {
  // static const deviceID = '29AA76B9-5E75-4BF9-9310-E31E60A4FD00618957068';
  // Future<dynamic> getLocationWeather() async {
  static String funcName = 'getUserInfo ';
  Future<bool> getUserInfoFromServer() async {
    String deviceID = userSettings.deviceID.value;
    print("About to call $funcName");
    try {
      Response response = await dio.get(apiURL + 'getUserInfo',
          queryParameters: {'UserToken': deviceID});

      Map userMap = response.data;
      print("$funcName Response found");
      print(response.data);
      userInfo = UserInfo.fromJson(userMap);
      return (true);
    } catch (e) {
      print("$funcName Error found");
      print(e);
      return (false);
    }
  }
}
