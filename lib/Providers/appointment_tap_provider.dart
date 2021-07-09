import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppointmentTabIndex appointmentTab = new AppointmentTabIndex();

class AppointmentTabIndex with ChangeNotifier{
  int tab = 1;
  void changeStatusIndex(int newTab){
    tab = newTab;
    notifyListeners();
  }
}