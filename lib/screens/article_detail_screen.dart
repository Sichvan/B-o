import 'package:flutter/material.dart';
import 'package:readability/article.dart' as readability;
import 'package:readability/readability.dart' as readability;
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart'; // Thêm: Cần để kiểm tra đăng nhập
import '../providers/auth_provider.dart'; // Thêm: Cần để kiểm tra đăng nhập
import 'auth_screen.dart'; // Thêm: Cần để điều hướng

class ArticleDetailScreen extends StatefulWidget {
  final String articleUrl;
  final String articleTitle;
  final String articleId; // Thêm: Cần cho chức năng Lưu/Bình luận

  const ArticleDetailScreen({
    super.key,
    required this.articleUrl,
    required this.articleTitle,
    required this.articleId, // Thêm
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  // Future để fetch nội dung bài viết sạch
  late final Future<readability.Article?> _articleFuture;

  @override
  void initState() {
    super.initState();
    _articleFuture = readability.parseAsync(widget.articleUrl).then((article) {
      return article;
      // Bỏ dòng return null ở đây (có vẻ là code chết từ trước)
    }).catchError((error) {
      print('Readability Error: $error'); // Thêm log lỗi
      return null;
    });
  }

  // --- THÊM HÀM MỚI ---
  // Hiển thị dialog yêu cầu đăng nhập
  void _showLoginRequiredDialog(BuildContext context) {
    // TODO: Chuyển các chuỗi cứng sang l10n
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yêu cầu đăng nhập'),
        content: const Text('Bạn phải đăng nhập để sử dụng chức năng này.'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Đăng nhập'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
  // --- KẾT THÚC HÀM MỚI ---

  @override
  Widget build(BuildContext context) {
    // Thêm AuthProvider để kiểm tra đăng nhập
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.articleTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: FutureBuilder<readability.Article?>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Hiển thị loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            // Hiển thị lỗi nếu có
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                      'Không thể tải nội dung bài viết. Vui lòng thử lại.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      // Reload
                      _articleFuture =
                          readability.parseAsync(widget.articleUrl).catchError((_) => null);
                    }),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else {
            final article = snapshot.data!;
            final title = article.title ?? widget.articleTitle;
            final content = article.content ?? '';
            final excerpt = article.excerpt ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isNotEmpty ? title : widget.articleTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- THÊM DẢI NÚT LƯU VÀ BÌNH LUẬN ---
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
                          // TODO: Logic lưu bài viết (dùng widget.articleId)
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
                          // TODO: Logic hiển thị/thêm bình luận (dùng widget.articleId)
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
                  // --- KẾT THÚC DẢI NÚT ---

                  if (content.isNotEmpty)
                    Html(
                      data: content,
                      style: {
                        'body': Style(
                          fontSize: FontSize(16),
                          lineHeight: LineHeight.number(1.5),
                        ),
                      },
                      onLinkTap: (url, _, __) {
                        // TODO: Xử lý mở link (nếu cần)
                      },
                    )
                  else
                    const Text(
                      'Không có nội dung.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  if (excerpt.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Tóm tắt: $excerpt',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

