import 'dart:convert';

List<AdminArticle> adminArticleFromJson(String str) =>
    List<AdminArticle>.from(
        json.decode(str).map((x) => AdminArticle.fromJson(x)));

class AdminArticle {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String language;
  final String category;
  final String sourceName;
  final String authorEmail; // Sẽ hiển thị 'ID: ...' hoặc 'email@...'
  final DateTime createdAt;

  AdminArticle({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.language,
    required this.category,
    required this.sourceName,
    required this.authorEmail,
    required this.createdAt,
  });

  factory AdminArticle.fromJson(Map<String, dynamic> json) {
    // --- SỬA LỖI ---
    // Xử lý trường 'author' linh hoạt
    String email = 'Không rõ';
    if (json["author"] != null) {
      if (json["author"] is Map<String, dynamic>) {
        // Trường hợp author được populate (khi fetch)
        email = json["author"]["email"] ?? 'Không rõ';
      } else if (json["author"] is String) {
        // Trường hợp author chỉ là ID (khi add/update)
        email = 'Admin (ID: ${json["author"]})';
      }
    }
    // --- KẾT THÚC SỬA ---

    return AdminArticle(
      id: json["_id"],
      title: json["title"],
      content: json["content"],
      imageUrl: json["imageUrl"],
      language: json["language"],
      category: json["category"],
      sourceName: json["sourceName"] ?? 'Tin tức Admin', // Thêm default
      authorEmail: email, // Dùng biến email đã xử lý
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  // Map này chỉ dùng để gửi đi, không cần 'id' hay 'author'
  Map<String, dynamic> toSendJson() => {
    "title": title,
    "content": content,
    "imageUrl": imageUrl,
    "language": language,
    "category": category,
  };
}

