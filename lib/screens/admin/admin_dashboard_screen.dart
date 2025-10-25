import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'admin_manage_users_screen.dart';
import 'admin_manage_articles_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  static const routeName = '/admin-dashboard';
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Quản Trị (Admin)'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardItem(
              context: context,
              icon: Icons.comment_bank_outlined,
              title: 'Quản lý Bình luận',
              onTap: () {
                // TODO: Điều hướng đến trang quản lý bình luận
                // Navigator.of(context).pushNamed('/admin-comments');
              },
            ),
            _buildDashboardItem(
              context: context,
              icon: Icons.article_outlined,
              title: 'Quản lý Bài viết',
              onTap: () {
                // TODO: Điều hướng đến trang quản lý bài viết
                Navigator.of(context).pushNamed(AdminManageArticlesScreen.routeName);
              },
            ),
            _buildDashboardItem(
              context: context,
              icon: Icons.people_outline,
              title: 'Quản lý Tài khoản',
              onTap: () {
                // TODO: Điều hướng đến trang quản lý tài khoản
                Navigator.of(context).pushNamed(AdminManageUsersScreen.routeName);
              },
            ),
            _buildDashboardItem(
              context: context,
              icon: Icons.settings_applications_outlined,
              title: 'Quản lý Ứng dụng',
              onTap: () {
                // TODO: Điều hướng đến trang cài đặt chung
                // Navigator.of(context).pushNamed('/admin-settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget con để xây dựng các ô chức năng cho dashboard
  Widget _buildDashboardItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
