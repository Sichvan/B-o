// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import '../models/news.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000/api';

  // --- SỬA ĐỔI ---
  // Thêm tham số 'language' vào hàm
  Future<List<News>> fetchNews(String category, String language) async {
    // Thêm category VÀ language vào query string
    final url = '$_baseUrl/news?category=$category&language=$language';
    final response = await http.get(Uri.parse(url));
    // --- KẾT THÚC SỬA ĐỔI ---

    if (response.statusCode == 200) {
      return newsFromJson(response.body);
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load news');
    }
  }
}