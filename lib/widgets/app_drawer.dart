// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Cài đặt & Menu',
              style: TextStyle(
                // Đảm bảo chữ trên header luôn dễ đọc
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontSize: 24,
              ),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Chế độ tối'),
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
            title: const Text('Chuyển ngôn ngữ'),
            onTap: () {
              // TODO: Thêm logic chuyển ngôn ngữ tại đây
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Bài báo đã lưu'),
            onTap: () {
              // TODO: Chuyển sang màn hình bài báo đã lưu
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch sử xem'),
            onTap: () {
              // TODO: Chuyển sang màn hình lịch sử xem
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Đăng nhập'),
            onTap: () {
              // TODO: Chuyển sang màn hình đăng nhập
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}