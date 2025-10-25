import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/admin_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_manage_users_screen.dart';
import 'screens/admin/admin_manage_articles_screen.dart';
import 'screens/admin/admin_edit_article_screen.dart';
// THÊM DÒNG NÀY:
import 'screens/article_detail_admin_content_screen.dart';

import 'screens/splash_screen.dart';
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, langProvider, child) {
          return MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false,
            locale: langProvider.currentLocale,
            // --- SỬA LỖI TYPO TẠI ĐÂY ---
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // --- KẾT THÚC SỬA ---
            supportedLocales: const [
              Locale('en'),
              Locale('vi'),
            ],

            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,

            home: Consumer<AuthProvider>(
              builder: (ctx, auth, _) {
                if (auth.isAuth) {
                  if (auth.role == 'admin') {
                    return const AdminDashboardScreen();
                  } else {
                    return const HomeScreen();
                  }
                }

                return FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) {
                    if (authResultSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    // Sau khi auto-login, kiểm tra lại
                    if (auth.isAuth && auth.role == 'admin') {
                      return const AdminDashboardScreen();
                    }
                    // Mặc định trả về HomeScreen (dù đã login hay chưa)
                    return const HomeScreen();
                  },
                );
              },
            ),
            routes: {
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              HomeScreen.routeName: (ctx) => const HomeScreen(),
              AdminDashboardScreen.routeName: (ctx) =>
              const AdminDashboardScreen(),
              AdminManageUsersScreen.routeName: (ctx) =>
              const AdminManageUsersScreen(),
              AdminManageArticlesScreen.routeName: (ctx) =>
              const AdminManageArticlesScreen(),
              AdminEditArticleScreen.routeName: (ctx) =>
              const AdminEditArticleScreen(),

              // THÊM ROUTE NÀY:
              ArticleDetailAdminContentScreen.routeName: (ctx) =>
              const ArticleDetailAdminContentScreen(),
            },
          );
        },
      ),
    );
  }
}

