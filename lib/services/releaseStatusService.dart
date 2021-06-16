import 'dart:convert';

import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:dio/dio.dart';

class ReleaseStatusModel {
  ReleaseStatusModel({
    this.currentRelease,
    this.retiredRelease,
    this.apiKey,
  });

  String currentRelease;
  String retiredRelease;
  String apiKey;

  factory ReleaseStatusModel.fromRawJson(String str) =>
      ReleaseStatusModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReleaseStatusModel.fromJson(Map<String, dynamic> json) =>
      ReleaseStatusModel(
        currentRelease: json["currentRelease"],
        retiredRelease: json["retiredRelease"],
        apiKey: json["apiKey"],
      );

  Map<String, dynamic> toJson() => {
        "currentRelease": currentRelease,
        "retiredRelease": retiredRelease,
        "apiKey": apiKey,
      };
}

class VersionService {
  static String funcName = 'Release Info ';
  ReleaseStatusModel releaseData = ReleaseStatusModel();

  Future<bool> getReleaseData() async {
    try {
      Response response = await dio.get(versionURL, queryParameters: {
        // 'deviceID': userSettings.deviceID,
      });

      // Map nearbyLocationsMap = response.data;
      print("$funcName response found");
      print(response.data);

      releaseData = ReleaseStatusModel.fromJson(response.data);

      print("$funcName Map complete");

      return (true);
    } catch (e) {
      print("$funcName Error found");
      print(e);
      return (false);
    }
  }

  bool get needsUpdate {
    final List<int> currentVersion = packageInfo.version
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> enforcedVersion = releaseData.retiredRelease
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    for (int i = 0; i < 3; i++) {
      if (enforcedVersion[i] > currentVersion[i]) return true;
    }
    return false;
  }

  bool get updateAvailable {
    final List<int> currentVersion = packageInfo.version
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> enforcedVersion = releaseData.currentRelease
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    for (int i = 0; i < 3; i++) {
      if (enforcedVersion[i] > currentVersion[i]) return true;
    }
    return false;
  }
}
