import 'package:flutter/material.dart';

enum AppTheme { light, dark, custom }

class ThemeProvider with ChangeNotifier {
  ThemeData _t = ThemeData.light();
  AppTheme _cur = AppTheme.light;
  ThemeData get themeData => _t;
  AppTheme get currentTheme => _cur;

  void setTheme(AppTheme th) {
    _cur = th;
    switch (th) {
      case AppTheme.light:
        _t = ThemeData.light();
        break;
      case AppTheme.dark:
        _t = ThemeData.dark();
        break;
      case AppTheme.custom:
        _t = ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.grey.shade100,
        );
        break;
    }
    notifyListeners();
  }
}