import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

LoadingScreen loadingScreen = new LoadingScreen();

class LoadingScreen with ChangeNotifier{
  bool createReservationLoading = false;
  bool updateReservationLoading = false;

  void changeCreateReservationLoading(){
    createReservationLoading = !createReservationLoading;
    notifyListeners();
  }

  void changeUpdateReservationLoading(){
    updateReservationLoading = !updateReservationLoading;
    notifyListeners();
  }

  void setFalseUpdateReservationLoading(bool val){
    updateReservationLoading = val;
    notifyListeners();
  }

  void initializeUpdateProvider(){
    updateReservationLoading = false;
  }
}