// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'theme/dark_light.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()), // <-- 3. Thêm LanguageProvider
      ],
      // 4. Dùng Consumer<ThemeProvider> VÀ <LanguageProvider>
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, child) { // <-- Sửa builder
          return MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false,

            // 5. Thêm cấu hình localization
            locale: langProvider.currentLocale, // Lấy locale từ provider
            localizationsDelegates: const [
              AppLocalizations.delegate, // Delegate từ file auto-gen
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // Tiếng Anh
              Locale('vi'), // Tiếng Việt
            ],
            // --- Kết thúc thêm ---

            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}