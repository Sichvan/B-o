import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse('$_baseUrl/news'));

    if (response.statusCode == 200) {
      return newsFromJson(response.body);
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load news');
    }
  }
}