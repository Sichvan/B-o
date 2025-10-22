import 'package:http/http.dart' as http;
import '../models/news.dart';

class ApiService {
  // Đảm bảo đây là IP của máy tính chạy server Node.js (10.0.2.2 là cho Android Emulator)
  static const String _baseUrl = 'http://10.0.2.2:5000/api';

  // --- SỬA ĐỔI ---
  // Thêm tham số 'category' vào hàm
  Future<List<News>> fetchNews(String category) async {
    // Thêm category vào query string của URL
    final response = await http.get(Uri.parse('$_baseUrl/news?category=$category'));
    // --- KẾT THÚC SỬA ĐỔI ---

    if (response.statusCode == 200) {
      // Dùng hàm newsFromJson mà bạn đã cung cấp
      return newsFromJson(response.body);
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load news');
    }
  }
}