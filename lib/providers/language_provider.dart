import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('vi');

  Locale get currentLocale => _currentLocale;

  void toggleLanguage() {
    if (_currentLocale == const Locale('vi')) {
      _currentLocale = const Locale('en');
    } else {
      _currentLocale = const Locale('vi');
    }
    notifyListeners();
    // TODO: Lưu lựa chọn này vào SharedPreferences nếu bạn muốn
  }
}