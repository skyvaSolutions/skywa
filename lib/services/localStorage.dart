import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

String readStringFromLocal(
    SharedPreferences prefs, String settingKey, String defaultValue) {
  String valueRead;
  valueRead = prefs.getString(settingKey);
  if (valueRead == null) {
    print(" $settingKey not found");
    prefs.setString(settingKey, defaultValue);
    return defaultValue;
  } else {
    print("$settingKey Found $valueRead.ttoString()");
    return valueRead;
  }
}

Future<String> readDeviceIDFromLocal(SharedPreferences prefs) async {
  String deviceID;
  deviceID = prefs.getString(userSettings.deviceID.key);
  if (deviceID == null) {
    print(" DeviceID not found");
    deviceID = Uuid().v1();
    prefs.setString(userSettings.deviceID.key, deviceID);
    return deviceID;
  } else {
    print("DeviceID Found $deviceID");
    return deviceID;
  }
}

updateNumberOfUsages(SharedPreferences prefs) {
  int numUsages;
  numUsages = prefs.getInt(userSettings.numUsages.key);
  if (numUsages == null) {
    print(" Number of usages not found");
    numUsages = 1;
    prefs.setInt(userSettings.numUsages.key, numUsages);
    return numUsages;
  } else {
    numUsages += 1;
    prefs.setInt(userSettings.numUsages.key, numUsages);
    return numUsages;
  }
}

double readDoubleFromLocal(
    SharedPreferences prefs, String settingKey, double defaultValue) {
  double valueRead;
  valueRead = prefs.getDouble(settingKey);
  if (valueRead == null) {
    print(" $settingKey not found");
    prefs.setDouble(settingKey, defaultValue);
    return defaultValue;
  } else {
    print("$settingKey Found $valueRead.ttoString()");
    return valueRead;
  }
}

int readIntFromLocal(
    SharedPreferences prefs, String settingKey, int defaultValue) {
  int valueRead;
  valueRead = prefs.getInt(settingKey);
  if (valueRead == null) {
    print(" $settingKey not found");
    prefs.setInt(settingKey, defaultValue);
    return defaultValue;
  } else {
    print("$settingKey Found $valueRead");
    return valueRead;
  }
}

bool readBoolFromLocal(
    SharedPreferences prefs, String settingKey, bool defaultValue) {
  bool valueRead;
  valueRead = prefs.getBool(settingKey);
  if (valueRead == null) {
    print(" $settingKey not found");
    prefs.setBool(settingKey, defaultValue);
    return defaultValue;
  } else {
    print("$settingKey Found $valueRead");
    return valueRead;
    // globalChimeOn = chimeOn;
  }
}
