import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/services/qAPIServices.dart';

class searchProvider with ChangeNotifier {
  List<NearbyQsModel> _searchData;
  bool _isSearching = false;
  List<NearbyQsModel> get searchdata => _searchData;
  bool get isSearching => _isSearching;
  void searching(String d) {
    print(d);
    _isSearching = true;
    _searchData = [];
    for (int i = 0; i < nearbyQs.length; i++) {
      String temp = nearbyQs[i].companyName;
      print(temp);
      if (temp.toLowerCase().contains(d.toLowerCase())) {
        _searchData.add(nearbyQs[i]);
      }
    }
    print(_searchData);
    notifyListeners();
  }

  void backPressed() {
    _isSearching = false;
    notifyListeners();
  }
}
