// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart'; // <-- 1. Import ThemeProvider
import 'screens/home_screen.dart';
import 'theme/dark_light.dart'; // <-- 2. Import file theme của bạn

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Sử dụng MultiProvider để quản lý nhiều provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // <-- 4. Thêm ThemeProvider
      ],
      // 5. Dùng Consumer<ThemeProvider> để build lại MaterialApp khi theme thay đổi
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false, // Tắt banner "Debug"

            // 6. Áp dụng theme từ file dark_light.dart
            theme: lightTheme, // Theme sáng
            darkTheme: darkTheme, // Theme tối

            // 7. Quyết định dùng theme nào dựa trên trạng thái của ThemeProvider
            themeMode: themeProvider.themeMode,

            home: const HomeScreen(), // Màn hình chính
          );
        },
      ),
    );
  }
}