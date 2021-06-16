import 'dart:io';

import 'package:skywa/Global&Constants/DeviceDetailsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

getDeviceInfo(BuildContext context) async {
  print("Hello World");
  userDevice.isTablet = Device.get().isTablet;
  userDevice.isPhone = Device.get().isPhone;
  userDevice.hasNotch = Device.get().hasNotch;
  userDevice.isAndroid = Device.get().isAndroid;
  userDevice.isIOS = Device.get().isIos;

  MediaQueryData _mediaQueryData = MediaQuery.of(context);
  userDevice.screenWidth = _mediaQueryData.size.width;
  userDevice.screenHeight = _mediaQueryData.size.height;
  userDevice.blockSizeHorizontal = userDevice.screenWidth / 100;
  userDevice.blockSizeVertical = userDevice.screenHeight / 100;

  double _safeAreaHorizontal =
      _mediaQueryData.padding.left + _mediaQueryData.padding.right;
  double _safeAreaVertical =
      _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  userDevice.safeBlockHorizontal =
      (userDevice.screenWidth - _safeAreaHorizontal) / 100;
  userDevice.safeBlockVertical =
      (userDevice.screenHeight - _safeAreaVertical) / 100;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    userDevice.osVersion = androidInfo.version.release;
    userDevice.manufacturer = androidInfo.manufacturer;
    userDevice.model = androidInfo.model;
  }

  if (Platform.isIOS) {
    var iosInfo = await deviceInfo.iosInfo;
    userDevice.osVersion = iosInfo.systemName + " " + iosInfo.systemVersion;
    userDevice.manufacturer = "Apple";
    userDevice.model = iosInfo.name;

    // iOS 13.1, iPhone 11 Pro Max iPhone
  }

  print(_mediaQueryData.orientation);
  print("SafeBlockVertical = ${userDevice.safeBlockVertical}");
  print("SafeBlockHorizontal = ${userDevice.safeBlockHorizontal}");
  print("Device height = ${userDevice.screenHeight}");
  print("Device width = ${userDevice.screenWidth}");
  print("Has Notch " + userDevice.hasNotch.toString());
  print("Is Tablet = " + userDevice.isTablet.toString());
  print("OS Version = " + userDevice.osVersion);
  print("Manufacturer = " + userDevice.manufacturer);
  print("Model = " + userDevice.model);
}
