import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- 1. THÊM BIẾN LƯU TRỮ TÌM KIẾM ---
  String _searchQuery = "";

  // --- 2. SỬA GETTER ĐỂ LỌC DANH SÁCH ---
  // List<News> get newsList => _newsList; // <-- Xóa hoặc comment dòng này
  List<News> get filteredNewsList { // <-- Thêm getter mới này
    if (_searchQuery.isEmpty) {
      return _newsList; // Trả về list đầy đủ nếu không tìm kiếm
    } else {
      // Trả về list đã lọc, không phân biệt hoa thường
      return _newsList
          .where((news) =>
          news.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
  // --- KẾT THÚC SỬA ĐỔI (2) ---

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- 3. THÊM PHƯƠNG THỨC CẬP NHẬT TÌM KIẾM ---
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // Thông báo cho UI build lại với list đã lọc
  }
  // --- KẾT THÚC THÊM (3) ---


  Future<void> fetchNewsByCategory(String category, String language) async {
    if (_newsList.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }
    _errorMessage = null;

    // --- 4. RESET TÌM KIẾM KHI ĐỔI CATEGORY ---
    _searchQuery = "";
    // --- KẾT THÚC THÊM (4) ---

    try {
      _newsList = await _apiService.fetchNews(category, language);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}