import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/app_drawer.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức Tổng hợp'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          // ... (các trường hợp isLoading, errorMessage, isEmpty giữ nguyên) ...

          if (newsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (newsProvider.errorMessage != null) {
            return Center(child: Text('Đã xảy ra lỗi: ${newsProvider.errorMessage}'));
          }

          if (newsProvider.newsList.isEmpty) {
            return const Center(child: Text('Không có bài báo nào để hiển thị.'));
          }

          // Trường hợp 4: Hiển thị danh sách bài báo
          return ListView.builder(
            itemCount: newsProvider.newsList.length,
            itemBuilder: (context, index) {
              final news = newsProvider.newsList[index];

              // --- SỬA TỪ ĐÂY ---
              // 2. Bọc Card bằng InkWell
              return InkWell(
                onTap: () {
                  // 3. Xử lý sự kiện nhấn
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        // 4. Truyền dữ liệu sang màn hình mới
                        articleUrl: news.link,
                        articleTitle: news.title,
                      ),
                    ),
                  );
                },
                child: Card( // Card gốc của bạn
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị ảnh
                      if (news.imageUrl != null)
                        Image.network(
                          news.imageUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Icon(Icons.broken_image_outlined, size: 50, color: Colors.grey),
                            );
                          },
                        ),

                      // Phần text
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              news.sourceName,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // --- SỬA ĐẾN ĐÂY ---
            },
          );
        },
      ),
    );
  }
}