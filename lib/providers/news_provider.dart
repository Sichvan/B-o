// lib/providers/news_provider.dart

import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // --- THÊM MỚI ---
  // Quản lý category đang được chọn, mặc định là 'top' (Tin nóng)
  String _selectedCategory = 'top';
  // --- KẾT THÚC THÊM MỚI ---

  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory; // Getter cho category

  // --- SỬA ĐỔI ---
  // Đổi tên hàm và nhận tham số category
  Future<void> fetchNewsByCategory(String category) async {
    // Nếu chọn lại category cũ mà đã có dữ liệu thì không load lại
    if (category == _selectedCategory && _newsList.isNotEmpty && !_isLoading) {
      return;
    }

    _selectedCategory = category; // Cập nhật category
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Báo cho UI biết là đang loading

    try {
      // Gọi service với category được truyền vào
      final news = await _apiService.fetchNews(category);
      _newsList = news;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Báo cho UI biết đã load xong
    }
  }
// --- KẾT THÚC SỬA ĐỔI ---
}