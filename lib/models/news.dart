import 'dart:convert';
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
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json["title"] ?? "Không có tiêu đề",
      description: json["description"],
      link: json["link"] ?? "",
      imageUrl: json["image_url"],
      pubDate: json["pubDate"] == null ? null : DateTime.parse(json["pubDate"]),
      sourceName: json["source_id"] ?? "Không rõ nguồn",
    );
  }
}