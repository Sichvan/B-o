import 'package:flutter/material.dart';

// --- Theme Sáng ---
// Giao diện sáng sủa với màu cam làm chủ đạo, tạo cảm giác năng động, vui tươi.
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.orange, // Màu cho các widget chính như CircularProgressIndicator
  primaryColor: Colors.orange, // Màu chính của ứng dụng
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange, // AppBar màu cam
    foregroundColor: Colors.white, // Chữ và icon trên AppBar màu trắng
    elevation: 2, // Thêm một chút bóng đổ cho AppBar
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[100], // Màu nền chung cho các trang
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.orange,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);

// --- Theme Tối ---
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    // --- SỬA Ở ĐÂY ---
    backgroundColor: Colors.blue, // Đổi từ Colors.black thành Colors.blue
    // --- KẾT THÚC SỬA ---
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);