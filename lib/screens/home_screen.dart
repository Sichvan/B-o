// lib/screens/home_screen.dart
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/news_provider.dart';
import '../widgets/app_drawer.dart'; // Đảm bảo bạn có file này
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, String> _categories = {
    'Tin nóng': 'top',
    'Xã hội': 'politics',
    'Thế giới': 'world',
    'Kinh tế': 'business',
    'Khoa học': 'science',
    'Văn hóa': 'entertainment',
    'Thể thao': 'sports',
    'Giải trí': 'entertainment',
    'Pháp luật': 'crime',
    'Giáo dục': 'education',
    'Sức khỏe': 'health',
    'Nhà đất': 'other',
    'Xe cộ': 'technology',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialCategory = _categories.values.first;
      Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(initialCategory);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,

        // === SỬA 1 ===
        // titleSpacing MẶC ĐỊNH SẼ CĂN LỀ TITLE VỚI ICON
        // Xóa dòng titleSpacing: 0 đi, hoặc set nó về null
        titleSpacing: NavigationToolbar.kMiddleSpacing, //Sử dụng giá trị mặc định

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              // === SỬA 2 ===
              // Xóa padding trái, để titleSpacing tự động căn lề
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Tin tức 24h',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,

              // === SỬA 3 ===
              // XÓA BỎ HOÀN TOÀN DÒNG `padding` MÀ CHÚNG TA ĐÃ THÊM TRƯỚC ĐÓ
              // padding: const EdgeInsets.only(left: 44.0), // <- XÓA DÒNG NÀY

              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: _categories.keys.map((String key) {
                return Tab(text: key);
              }).toList(),
              onTap: (index) {
                final categoryKey = _categories.values.elementAt(index);
                Provider.of<NewsProvider>(context, listen: false)
                    .fetchNewsByCategory(categoryKey);
              },
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(), // Đảm bảo bạn có Widget AppDrawer này
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          // ... (Phần body giữ nguyên không thay đổi) ...
          if (newsProvider.isLoading && newsProvider.newsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (newsProvider.errorMessage != null && newsProvider.newsList.isEmpty) {
            return Center(child: Text('Đã xảy ra lỗi: ${newsProvider.errorMessage}'));
          }

          return ListView.builder(
            itemCount: newsProvider.newsList.length,
            itemBuilder: (context, index) {
              final news = newsProvider.newsList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        articleUrl: news.link,
                        articleTitle: news.title,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
            },
          );
        },
      ),
    );
  }
}