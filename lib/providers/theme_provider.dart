import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider<AppTheme>((_) => AppTheme());

class AppTheme extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  changeMode(ThemeMode m) {
    _mode = m;
    notifyListeners();
  }
}
