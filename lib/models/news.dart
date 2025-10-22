// lib/models/news.dart

import 'dart:convert';

// Hàm helper để parse một chuỗi JSON thành một danh sách các đối tượng News
List<News> newsFromJson(String str) => List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

class News {
  final String title;
  final String? description;
  final String link;
  final String? imageUrl;
  final DateTime? pubDate;
  final String sourceName;

  News({
    required this.title,
    this.description,
    required this.link,
    this.imageUrl,
    this.pubDate,
    required this.sourceName,
  });

  // Factory constructor để tạo một đối tượng News từ một map JSON
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      // Ánh xạ các trường từ JSON của NewsData.io
      title: json["title"] ?? "Không có tiêu đề",
      description: json["description"],
      link: json["link"] ?? "", // Đảm bảo link không bao giờ null
      imageUrl: json["image_url"],
      // Xử lý an toàn trường hợp pubDate có thể null
      pubDate: json["pubDate"] == null ? null : DateTime.parse(json["pubDate"]),
      sourceName: json["source_id"] ?? "Không rõ nguồn",
    );
  }
}