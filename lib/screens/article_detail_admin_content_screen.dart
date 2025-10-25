import 'package:flutter/material.dart';
import '../models/display_article.dart';
import '../providers/auth_provider.dart'; // Cần để kiểm tra đăng nhập
import '../screens/auth_screen.dart'; // Cần để điều hướng
import 'package:provider/provider.dart'; // Cần để kiểm tra đăng nhập
import 'package:intl/intl.dart'; // Thêm để format ngày tháng

class ArticleDetailAdminContentScreen extends StatelessWidget {
  static const routeName = '/article-detail-admin';

  const ArticleDetailAdminContentScreen({super.key});

  // Hàm private để hiển thị dialog yêu cầu đăng nhập
  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'), // TODO: Chuyển sang l10n
        content: const Text(
            'Bạn phải đăng nhập để sử dụng chức năng này.'), // TODO: Chuyển sang l10n
        actions: [
          TextButton(
            child: const Text('Hủy'), // TODO: Chuyển sang l10n
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Đăng nhập'), // TODO: Chuyển sang l10n
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Lấy bài viết từ arguments
    final article =
    ModalRoute.of(context)!.settings.arguments as DisplayArticle;

    // 2. Lấy auth provider để kiểm tra đăng nhập
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Nguồn và Ngày đăng (SỬA LỖI: Bỏ kiểm tra null)
            Text(
              '${article.sourceName} - ${DateFormat('dd/MM/yyyy, HH:mm').format(article.pubDate)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Hình ảnh (nếu có)
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                          child: Icon(Icons.broken_image_outlined,
                              size: 50, color: Colors.grey)),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Dải nút Lưu và Bình luận
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  tooltip: 'Lưu bài viết', // TODO: Chuyển sang l10n
                  onPressed: () {
                    if (!auth.isAuth) {
                      _showLoginRequiredDialog(context);
                      return;
                    }
                    // TODO: Logic lưu bài viết
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('TODO: Xử lý lưu bài viết')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  tooltip: 'Bình luận', // TODO: Chuyển sang l10n
                  onPressed: () {
                    if (!auth.isAuth) {
                      _showLoginRequiredDialog(context);
                      return;
                    }
                    // TODO: Logic hiển thị/thêm bình luận
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('TODO: Xử lý bình luận')),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Nội dung bài viết
            // SỬA LỖI: Dùng [adminContent] thay vì [content]
            Text(
              article.adminContent ?? 'Không có nội dung chi tiết.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

