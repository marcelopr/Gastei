import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  final String key = 'theme';
  bool isDarkModeOn = false;
  SharedPreferences _preferences;

  ThemeState() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  _loadFromPrefs() async {
    await _initPrefs();
    isDarkModeOn = _preferences.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _preferences.setBool(key, isDarkModeOn);
  }

  void updateTheme(bool isDarkModeOn) {
    this.isDarkModeOn = isDarkModeOn;
    notifyListeners();
    _saveToPrefs();
    print('DarkMode: $isDarkModeOn');
  }
}
