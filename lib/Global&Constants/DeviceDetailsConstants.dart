DeviceDetails userDevice = DeviceDetails();

class DeviceDetails {
  double screenWidth;
  double screenHeight;
  double blockSizeHorizontal;
  double blockSizeVertical;

  double safeBlockHorizontal;
  double safeBlockVertical;

  bool isPhone;
  bool isTablet;
  bool hasNotch;
  bool isAndroid;
  bool isIOS;
  String osVersion;
  String manufacturer;
  String model;
}
