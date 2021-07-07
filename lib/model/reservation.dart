import 'package:skywa/model/attendee.dart';

class Reservation {
  String DeviceID;
  String QID;
  String QJoinTime;
  String OriginalIETA;
  String LatestETA;
  String MemberState;
  String MemberQueuePosition;
  String LastReportedLocationStamp;
  String LastReportedLocationAccuracy;
  String NoShowCount;
  String ReservationID;
  String ReservationStartTime;
  String MemberStateUpdateTimeStamp;
  int WaitTime;
  String ReservationType;
  String PhoneNumber;
  String Latitude;
  String Longitude;
  String NumberOfPeopleOnReservation;
  String ReservationCreatedTimeStamp;
  String ReservationUpdatedTimeStamp;
  String CompanyName;
  String LocationaName;
  String Address;
  String CompanyLogoURL;
  String QName;
  List<dynamic> AuthorizedUsers;
  List<dynamic> AttendeeData;

  Reservation(
      this.DeviceID,
      this.QID,
      this.QJoinTime,
      this.OriginalIETA,
      this.LatestETA,
      this.MemberState,
      this.MemberQueuePosition,
      this.LastReportedLocationStamp,
      this.LastReportedLocationAccuracy,
      this.NoShowCount,
      this.ReservationID,
      this.ReservationStartTime,
      this.MemberStateUpdateTimeStamp,
      this.WaitTime,
      this.ReservationType,
      this.PhoneNumber,
      this.Latitude,
      this.Longitude,
      this.NumberOfPeopleOnReservation,
      this.ReservationCreatedTimeStamp,
      this.ReservationUpdatedTimeStamp,
      this.CompanyName,
      this.LocationaName,
      this.Address,
      this.CompanyLogoURL,
      this.QName,
      this.AuthorizedUsers,
      this.AttendeeData);

  factory Reservation.fromMap(Map json) {
    return Reservation(
        json['DeviceID'],
        json['QID'],
        json['QJoinTime'],
        json['OriginalIETA'],
        json['LatestETA'],
        json['MemberState'],
        json['MemberQueuePosition'],
        json['LastReportedLocationStamp'],
        json['LastReportedLocationAccuracy'],
        json['NoShowCount'],
        json['ReservationID'],
        json['ReservationStartTime'],
        json['MemberStateUpdateTimeStamp'],
        json['WaitTime'],
        json['ReservationType'],
        json['PhoneNumber'],
        json['Latitude'],
        json['Longitude'],
        json['NumberOfPeopleOnReservation'],
        json['ReservationCreatedTimeStamp'],
        json['ReservationUpdatedTimeStamp'],
        json['CompanyName'],
        json['LocationaName'],
        json['Address'],
        json['CompanyLogoURL'],
        json['QName'],
        json['AuthorizedUsers'],
        json['AttendeeData'],
    );
  }
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      json['DeviceID'],
      json['QID'],
      json['QJoinTime'],
      json['OriginalIETA'],
      json['LatestETA'],
      json['MemberState'],
      json['MemberQueuePosition'],
      json['LastReportedLocationStamp'],
      json['LastReportedLocationAccuracy'],
      json['NoShowCount'],
      json['ReservationID'],
      json['ReservationStartTime'],
      json['MemberStateUpdateTimeStamp'],
      json['WaitTime'],
      json['ReservationType'],
      json['PhoneNumber'],
      json['Latitude'],
      json['Longitude'],
      json['NumberOfPeopleOnReservation'],
      json['ReservationCreatedTimeStamp'],
      json['ReservationUpdatedTimeStamp'],
      json['CompanyName'],
      json['LocationaName'],
      json['Address'],
      json['CompanyLogoURL'],
      json['QName'],
      json['AuthorizedUsers'],
      json['AttendeeData'],
    );
  }
}
