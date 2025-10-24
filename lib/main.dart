// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart'; // <-- 1. Import AuthProvider

// Screens
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart'; // <-- 2. Import AuthScreen
import 'screens/admin/admin_dashboard_screen.dart'; // <-- 3. Import Admin Screen
import 'screens/splash_screen.dart'; // <-- 4. Import Splash Screen

// Theme & l10n
import 'theme/dark_light.dart';
import 'l10n/app_localizations.dart';
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
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()), // <-- 5. Thêm AuthProvider
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, child) {
          return MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false,

            locale: langProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('vi'),
            ],

            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,

            // --- 6. SỬA LẠI PHẦN ĐIỀU HƯỚNG CHÍNH ---
            home: Consumer<AuthProvider>(
              builder: (ctx, auth, _) {
                // Nếu đã đăng nhập...
                if (auth.isAuth) {
                  // Kiểm tra vai trò
                  if (auth.role == 'admin') {
                    return const AdminDashboardScreen();
                  } else {
                    return const HomeScreen(); // User bình thường
                  }
                }

                // Nếu chưa đăng nhập, thử tự động đăng nhập
                // (Đây là logic khi app vừa khởi động)
                return FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) {
                    // Khi đang kiểm tra token...
                    if (authResultSnapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    }

                    // Sau khi kiểm tra xong (dù thành công hay thất bại)
                    // auth.isAuth sẽ được cập nhật
                    // Chúng ta kiểm tra lại lần nữa
                    if (auth.isAuth && auth.role == 'admin') {
                      return const AdminDashboardScreen();
                    }

                    // Đối với mọi trường hợp khác (user đã login, hoặc khách)
                    // đều hiển thị HomeScreen
                    return const HomeScreen();
                  },
                );
              },
            ),
            // --- KẾT THÚC SỬA ĐỔI ---

            // --- 7. THÊM ROUTES ĐỂ CÓ THỂ GỌI AuthScreen THỦ CÔNG ---
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              AdminDashboardScreen.routeName: (ctx) => const AdminDashboardScreen(),
              // Thêm các routes cho màn hình "Bài đã lưu", "Lịch sử" ở đây
            },
          );
        },
      ),
    );
  }
}