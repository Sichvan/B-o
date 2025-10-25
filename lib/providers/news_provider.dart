import 'package:flutter/material.dart';
import '../models/news.dart';
import '../models/display_article.dart'; // Thêm: Model thống nhất
import '../models/admin_article.dart'; // Thêm: Model Admin
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // SỬ DỤNG MODEL THỐNG NHẤT
  List<DisplayArticle> _newsList = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = "";

  // SỬ DỤNG MODEL THỐNG NHẤT
  List<DisplayArticle> get filteredNewsList {
    if (_searchQuery.isEmpty) {
      return _newsList;
    } else {
      return _newsList
          .where((news) =>
          news.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchNewsByCategory(String category, String language) async {
    // Đặt isLoading về true khi bắt đầu fetch (kể cả khi refresh)
    _isLoading = true;
    _errorMessage = null;
    _searchQuery = "";
    notifyListeners();

    try {
      // 1. Tạo list rỗng
      List<DisplayArticle> combinedList = [];

      // 2. Gọi cả hai API song song
      final apiNewsFuture = _apiService.fetchNews(category, language);
      final adminNewsFuture = _apiService.fetchPublicAdminArticles(category, language); // Truyền category & language

      // 3. Chờ cả hai hoàn thành
      final results = await Future.wait([apiNewsFuture, adminNewsFuture]);

      // 4. Xử lý kết quả tin API (News)
      final List<News> apiNews = results[0] as List<News>;
      combinedList.addAll(apiNews.map((news) => DisplayArticle.fromNews(news)));

      // 5. Xử lý kết quả tin Admin (AdminArticle)
      final List<dynamic> adminNewsData = results[1] as List<dynamic>;
      final List<AdminArticle> adminNews = adminNewsData.map((data) => AdminArticle.fromJson(data)).toList();
      combinedList.addAll(adminNews.map((article) => DisplayArticle.fromAdminArticle(article)));

      // 6. Sắp xếp danh sách gộp theo ngày tháng (mới nhất lên đầu)
      combinedList.sort((a, b) => b.pubDate.compareTo(a.pubDate));

      _newsList = combinedList;

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

