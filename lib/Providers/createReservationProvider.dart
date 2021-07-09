import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Global&Constants/UserSettingsConstants.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/Providers/appointment_tap_provider.dart';
import 'package:skywa/Providers/loading_provider.dart';
import 'package:skywa/components/show_more_info_dialog.dart';
import 'package:skywa/screens/current_sreen.dart';
import 'package:skywa/screens/profileEditScreen.dart';
import 'package:skywa/services/locationServices.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class createReservationProvider with ChangeNotifier {
  bool loading = false;
  Future<void> createReservation(BuildContext context ,String date, String CompanyName, int index , Function() goToAppointmentScreen , Function() goToCurrentScreen , bool returnBack) async {
    var uuid = Uuid();
    String deviceId = userSettings.deviceID.value;
    String startTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(
        DateTime.now());
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
      "LastReportedLocationTimeStamp": startTime,
      "MemberStateUpdateTimeStamp": startTime,
      "ReservationType": "Vax",
      "PhoneNumber": "+1 242-302-4710",
      "NumberOfPeopleOnReservation": "1",
      "LocationName": CompanyName,
      "AttendeeData": [],
      "CompanyName": CompanyName
    };
    print(data);
    print("Adding a Reservation");
    var response = await dio.post(
        "https://shoeboxtx.veloxe.com:36251/api/AddorUpdateReservationPost",
        data: data);
    print(response.data);
    DateTime resAddedDate = convertDateFromString(date);
    DateTime today = DateTime.now();
    if (resAddedDate.day == today.day && resAddedDate.month == today.month &&
        resAddedDate.year == today.year)
      Provider.of<AppointmentTabIndex>(context, listen: false)
          .changeStatusIndex(1);
    if (resAddedDate.day > today.day || resAddedDate.month > today.month || resAddedDate.year > today.year)
      Provider.of<AppointmentTabIndex>(context, listen: false)
          .changeStatusIndex(2);
    Navigator.pop(context);
    showDialog(context: context, builder: (BuildContext context) {
        Map<String, String> dateTime = convertDateToProperFormat(resAddedDate);
        return CustomDialog(goToAppointmentScreen: goToAppointmentScreen,
          companyName: CompanyName,
          reservationDate: dateTime['Date'],
          reservationTime: dateTime['Time'],
          goToCurrentScreen : goToCurrentScreen,
          returnBack : returnBack,
          reservationId : resId,
          tab : Provider.of<AppointmentTabIndex>(context).tab,
          //popDialog:(){Navigator.pop(context);}
        );
    });
  }
}


