import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';

class AdminManageUsersScreen extends StatefulWidget {
  static const routeName = '/admin-manage-users';
  const AdminManageUsersScreen({super.key});

  @override
  State<AdminManageUsersScreen> createState() => _AdminManageUsersScreenState();
}

class _AdminManageUsersScreenState extends State<AdminManageUsersScreen> {
  late Future<void> _fetchUsersFuture;

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token!;
    _fetchUsersFuture =
        Provider.of<AdminProvider>(context, listen: false).fetchUsers(token);
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(String userId, String userName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận Xóa'),
        content: Text('Bạn có chắc muốn xóa tài khoản $userName?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final token = Provider.of<AuthProvider>(context, listen: false).token!;
        await Provider.of<AdminProvider>(context, listen: false)
            .deleteUser(userId, token);
      } catch (e) {
        await _showErrorDialog(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Tài khoản'),
      ),
      body: FutureBuilder(
        future: _fetchUsersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<AdminProvider>(
            builder: (context, adminProvider, child) {
              // SỬA LỖI TẠI ĐÂY
              if (adminProvider.isLoadingUsers) {
                return const Center(child: CircularProgressIndicator());
              }
              // SỬA LỖI TẠI ĐÂY
              if (adminProvider.errorUsers != null) {
                return Center(child: Text(adminProvider.errorUsers!));
              }
              if (adminProvider.users.isEmpty) {
                return const Center(
                  child: Text('Không tìm thấy tài khoản user nào.'),
                );
              }

              return ListView.builder(
                itemCount: adminProvider.users.length,
                itemBuilder: (ctx, index) {
                  final user = adminProvider.users[index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user.email[0].toUpperCase()),
                      ),
                      title: Text(user.email),
                      subtitle: Text('ID: ${user.id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(user.id, user.email),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

