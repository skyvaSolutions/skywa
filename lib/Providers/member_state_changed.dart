import 'package:flutter/material.dart';
import 'package:skywa/api_responses/recent_reservation.dart';

MemberStateChanged memberStateChanged = new MemberStateChanged();

class MemberStateChanged with ChangeNotifier{
  int statusIndex ;
  MemberStateChanged(){
    String state = currentReservation.currentRes.MemberState;
    if (state == "Not Arrived") {
      statusIndex = 0;
    }
    if (state == "Arrived") {
      statusIndex = 1;
    }
    if (state == "Called to Enter") {
      statusIndex = 2;
    }
    if (state == "In Facility") {
      statusIndex = 3;
    }
  }

  void changeStatusIndex(int newIndex){
    statusIndex = newIndex;
    notifyListeners();
  }
}