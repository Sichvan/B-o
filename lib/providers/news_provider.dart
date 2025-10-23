// lib/providers/news_provider.dart
import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- SỬA ĐỔI ---
  // Thêm tham số 'language'
  Future<void> fetchNewsByCategory(String category, String language) async {
    // --- KẾT THÚC SỬA ĐỔI ---

    // Chỉ set loading nếu list rỗng (tránh loading khi chuyển tab)
    if (_newsList.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }

    _errorMessage = null; // Xóa lỗi cũ

    try {
      // --- SỬA ĐỔI ---
      // Truyền 'language' vào service
      _newsList = await _apiService.fetchNews(category, language);
      // --- KẾT THÚC SỬA ĐỔI ---
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}