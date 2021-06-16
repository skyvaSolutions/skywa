import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode;
  bool get DarkMode => this._isDarkMode;
  void checkMode() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _isDarkMode =
        _pref.getBool("theme") == null ? false : _pref.getBool("theme");
    print(_isDarkMode);
    notifyListeners();
  }

  void changeMode() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    this._isDarkMode = !_isDarkMode;
    _pref.setBool("theme", _isDarkMode);
    notifyListeners();
  }
}
