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
// Giao diện tối hiện đại, sử dụng màu đen và xanh dương để làm nổi bật nội dung.
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue, // Màu cho các widget chính trong theme tối
  primaryColor: Colors.blue,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // AppBar màu đen tuyền
    foregroundColor: Colors.white, // Chữ và icon trên AppBar màu trắng
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // Màu nền tối tiêu chuẩn
  cardColor: const Color(0xFF1E1E1E), // Màu cho các thẻ (Card)
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

