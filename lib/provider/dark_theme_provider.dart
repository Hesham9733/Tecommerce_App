import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/dark_theme_prefernce.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePrefernces darkThemePrefernces = DarkThemePrefernces();

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePrefernces.setDarkTheme(value);
    notifyListeners();
  }
}
