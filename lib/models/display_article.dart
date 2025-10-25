import '../models/news.dart';
import '../models/admin_article.dart';

/// Model thống nhất để hiển thị tin tức trên HomeScreen.
/// Gộp dữ liệu từ 2 nguồn: [News] (từ API) và [AdminArticle] (từ DB).
class DisplayArticle {
  final String id;
  final String title;
  final String? imageUrl;
  final String sourceName;
  final DateTime pubDate;
  final bool isFromAdmin; // <-- Lỗi của bạn là do thiếu trường này

  // Dùng cho điều hướng thông minh
  final String articleUrl; // <-- Lỗi của bạn là do đây là String (không phải String?)
  final String? adminContent;

  DisplayArticle({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.sourceName,
    required this.pubDate,
    required this.isFromAdmin,
    required this.articleUrl,
    this.adminContent,
  });

  // Constructor để chuyển đổi từ [News] (API)
  DisplayArticle.fromNews(News news)
      : id = news.link, // Dùng link làm ID cho tin API
        title = news.title,
        imageUrl = news.imageUrl,
        sourceName = news.sourceName,
        pubDate = news.pubDate ?? DateTime.now(),
        isFromAdmin = false,
        articleUrl = news.link, // link là String (không null)
        adminContent = null;

  // Constructor để chuyển đổi từ [AdminArticle] (DB)
  DisplayArticle.fromAdminArticle(AdminArticle article)
      : id = article.id,
        title = article.title,
        imageUrl = article.imageUrl,
        sourceName = article.sourceName,
        pubDate = article.createdAt,
        isFromAdmin = true,
        articleUrl = '', // Tin Admin không có URL ngoài, gán giá trị rỗng (String không null)
        adminContent = article.content;
}

