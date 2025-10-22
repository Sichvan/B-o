// lib/providers/news_provider.dart
import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Báo cho UI biết là đang loading

    try {
      final news = await _apiService.fetchNews();
      _newsList = news;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Báo cho UI biết đã load xong (thành công hoặc thất bại)
    }
  }
}