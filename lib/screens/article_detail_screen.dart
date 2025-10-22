import 'package:flutter/material.dart';
import 'package:readability/article.dart' as readability;
import 'package:readability/readability.dart' as readability;
import 'package:flutter_html/flutter_html.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String articleUrl;
  final String articleTitle;

  const ArticleDetailScreen({
    super.key,
    required this.articleUrl,
    required this.articleTitle,
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
    // Gọi parseAsync để extract nội dung từ URL
    _articleFuture = readability.parseAsync(widget.articleUrl).then((article) {
      // Không cần kiểm tra null ở đây vì parseAsync có thể trả về null, nhưng then sẽ xử lý
      if (article != null) {
        // debugPrint('Title: ${article.title}');  // Thay print bằng debugPrint nếu cần, hoặc bỏ
        // debugPrint('Content length: ${article.content?.length ?? 0}');  // Safe access
        return article;
      }
      return null;
    }).catchError((error) {
      // debugPrint('Lỗi khi fetch/parse: $error');  // Tương tự
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('Không thể tải nội dung bài viết. Vui lòng thử lại.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),  // Reload
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else {
            // Hiển thị nội dung sạch
            final article = snapshot.data!;  // Safe vì đã check null
            final title = article.title ?? widget.articleTitle;  // Fallback nếu title null
            final content = article.content ?? '';  // Fallback empty string
            final excerpt = article.excerpt ?? '';  // Tương tự

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title an toàn
                  Text(
                    title.isNotEmpty ? title : widget.articleTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Render nội dung HTML sạch (loại bỏ ads)
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
                        // Xử lý click link nếu cần (mở WebView hoặc browser)
                        // debugPrint('Link tapped: $url');
                      },
                    )
                  else
                    const Text(
                      'Không có nội dung.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  // Tùy chọn: Hiển thị excerpt nếu muốn
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