// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _role;
  String? _userId;
  String? _email; // <-- 1. THÊM BIẾN EMAIL

  // Dùng IP của server Node.js
  final String _baseUrl = 'http://10.0.2.2:5000/api/auth';

  bool get isAuth => _token != null;
  String? get token => _token;
  String? get role => _role;
  String? get userId => _userId;
  String? get email => _email; // <-- 2. THÊM GETTER CHO EMAIL

  Future<void> _authenticate(
      String email, String password, String endpoint) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      // Sửa logic xử lý lỗi (an toàn hơn)
      if (response.statusCode != 200 && response.statusCode != 201) {
        try {
          final responseData = json.decode(response.body);
          throw (responseData['msg'] ?? 'Đã xảy ra lỗi từ server');
        } catch (e) {
          throw (response.body.isNotEmpty ? response.body : 'Đã xảy ra lỗi');
        }
      }

      // Chỉ decode khi đã thành công
      final responseData = json.decode(response.body);

      // Lưu state
      _token = responseData['token'];
      _role = responseData['user']['role'];
      _userId = responseData['user']['id'];
      _email = responseData['user']['email']; // <-- 3. LƯU EMAIL TỪ RESPONSE

      notifyListeners();

      // Lưu vào bộ nhớ máy
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
      prefs.setString('role', _role!);
      prefs.setString('userId', _userId!);
      prefs.setString('email', _email!); // <-- 4. LƯU EMAIL VÀO PREFS

    } catch (error) {
      rethrow; // Ném lỗi ra để AuthScreen xử lý
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  Future<void> register(String email, String password) async {
    return _authenticate(email, password, 'register');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }
    _token = prefs.getString('token');
    _role = prefs.getString('role');
    _userId = prefs.getString('userId');
    _email = prefs.getString('email'); // <-- 5. TẢI EMAIL TỪ PREFS
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _role = null;
    _userId = null;
    _email = null; // <-- 6. XÓA EMAIL KHI LOGOUT
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Xóa tất cả dữ liệu đã lưu
  }
}