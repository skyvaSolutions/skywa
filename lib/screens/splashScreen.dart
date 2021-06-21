import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/Providers/ThemeProvider.dart';
import 'package:skywa/api_calls/find_users.dart';
import 'package:skywa/api_responses/get_person.dart';
import 'package:skywa/model/person.dart';
import 'package:skywa/screens/homeScreen.dart';
import 'package:skywa/screens/onBoarding.dart';
import 'package:skywa/services/deviceInfoService.dart';
import 'package:skywa/services/localStorage.dart';
import 'package:skywa/services/locationServices.dart';
import 'package:skywa/services/qAPIServices.dart';
import 'package:skywa/services/releaseStatusService.dart';
import 'package:skywa/services/userServices.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashScreen';
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final p = Provider.of<ThemeProvider>(context, listen: false);
      p.checkMode();
    });

    initAll();
  }

  @override
  Widget build(BuildContext context) {
    getDeviceInfo(context);
    return Scaffold(
      body: Center(
        child: Text('Put Some Cool Splash Screen Here'),
      ),
    );
  }

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _messaging;

  void initAll() async {
    const locationErrorSnackBar = SnackBar(
      //  backgroundColor: (Colors.blue),
      content: Text('Location Services disabled using default location, '),
      duration: const Duration(milliseconds: 3000),
    );
    if (dio == null) {
      BaseOptions options = new BaseOptions(
          baseUrl: "your base url",
          receiveDataWhenStatusError: true,
          connectTimeout: 30 * 1000, // 30 seconds
          receiveTimeout: 30 * 1000 // 30 seconds
          );

      dio = new Dio(options);
    }
    await getProfileData();
    print("Did I return");

    Location location = Location();
    if (await location.getCurrentLocation()) {
      print("returned from location");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(locationErrorSnackBar);
    }
    UserService userService = UserService();
    await userService.getUserInfoFromServer();
    GetNearbyQService getNearbyQService = GetNearbyQService();
    await getNearbyQService.getNearbyQueues();
    if (userSettings.numUsages.value < 2) {
      Navigator.pushReplacementNamed(context, OnBoardingPage.id);
    } else {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
/////////////////////////calling GetMyPeople API to check whether there is a registered customer or not with this device//////////////////////////////////////////////////////
     findUsers.returnPerson(context);
  }
}
Future<void> getProfileData() async {
  print("Getting profile Data");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userSettings.deviceID.value = await readDeviceIDFromLocal(prefs);
  userSettings.retiredRelease.value =
      readBoolFromLocal(prefs, userSettings.retiredRelease.key, false);
  userSettings.userSetting1.value =
      readBoolFromLocal(prefs, userSettings.userSetting1.key, false);
  userSettings.numUsages.value = updateNumberOfUsages(prefs);
}




class PushNotification {
  PushNotification({
    this.title,
    this.body,
    dataBody,
  });
  String title;
  String body;
}
