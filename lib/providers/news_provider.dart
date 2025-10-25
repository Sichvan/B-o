import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = "";

  List<News> get filteredNewsList {
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
    if (_newsList.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }
    _errorMessage = null;
    _searchQuery = "";

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