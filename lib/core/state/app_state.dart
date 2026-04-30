import 'package:flutter/material.dart';

/// App-wide state: theme mode + currently selected tab.
class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  int _tabIndex = 0;

  ThemeMode get themeMode => _themeMode;
  int get tabIndex => _tabIndex;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setTab(int i) {
    if (_tabIndex == i) return;
    _tabIndex = i;
    notifyListeners();
  }
}
