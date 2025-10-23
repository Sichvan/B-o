// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Lấy đối tượng l10n (localization)
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            // 4. Thay thế text
            child: Text(
              l10n.settingsAndMenu, // <-- SỬA
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontSize: 24,
              ),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                // 4. Thay thế text
                title: Text(l10n.darkMode), // <-- SỬA
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (bool value) {
                  context.read<ThemeProvider>().toggleTheme(value);
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.language),
            // 4. Thay thế text
            title: Text(l10n.switchLanguage), // <-- SỬA
            onTap: () {
              // 5. Thêm logic chuyển ngôn ngữ
              context.read<LanguageProvider>().toggleLanguage();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            // 4. Thay thế text
            title: Text(l10n.savedArticles), // <-- SỬA
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            // 4. Thay thế text
            title: Text(l10n.viewHistory), // <-- SỬA
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            // 4. Thay thế text
            title: Text(l10n.login), // <-- SỬA
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}