// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Mặc định ban đầu là chế độ sáng
  ThemeMode _themeMode = ThemeMode.light;

  // Getter để các widget khác có thể đọc trạng thái hiện tại
  ThemeMode get themeMode => _themeMode;

  // Kiểm tra xem có phải đang ở chế độ tối không
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Hàm để chuyển đổi theme
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    // Thông báo cho các widget đang lắng nghe để chúng build lại
    notifyListeners();
  }
}