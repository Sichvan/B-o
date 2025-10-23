// lib/screens/home_screen.dart
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/app_drawer.dart';
import 'article_detail_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // --- 3. Xóa Map _categories ở đây ---

  // Biến để lưu trữ Map categories, sẽ được khởi tạo trong didChangeDependencies
  Map<String, String> _categories = {};

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với length = 0, sẽ cập nhật sau
    _tabController = TabController(length: 0, vsync: this);
  }

  // --- 4. Sử dụng didChangeDependencies ---
  // Hàm này được gọi sau initState và mỗi khi dependencies thay đổi (như Locale)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final l10n = AppLocalizations.of(context)!;

    // Định nghĩa categories DỰA TRÊN ngôn ngữ hiện tại
    final newCategories = {
      l10n.categoryTop: 'top',
      l10n.categoryPolitics: 'politics',
      l10n.categoryWorld: 'world',
      l10n.categoryBusiness: 'business',
      l10n.categoryScience: 'science',
      l10n.categoryEntertainment: 'entertainment',
      l10n.categorySports: 'sports',
      l10n.categoryEntertainment2: 'entertainment',
      l10n.categoryCrime: 'crime',
      l10n.categoryEducation: 'education',
      l10n.categoryHealth: 'health',
      l10n.categoryOther: 'other',
      l10n.categoryTechnology: 'technology',
    };

    // Chỉ cập nhật TabController nếu số lượng tab thay đổi
    if (newCategories.length != _categories.length) {
      _categories = newCategories;
      _tabController.dispose(); // Hủy controller cũ
      _tabController = TabController(length: _categories.length, vsync: this);

      // Thêm listener để gọi API khi tab được chọn
      _tabController.addListener(_handleTabSelection);

      // Gọi API cho tab đầu tiên sau khi khởi tạo
      _fetchInitialNews();
    } else {
      // Nếu chỉ đổi ngôn ngữ (số tab k đổi), cập nhật lại _categories
      _categories = newCategories;
    }
  }

  void _fetchInitialNews() {
    if (_categories.isNotEmpty) {
      final initialCategory = _categories.values.first;
      // Lấy ngôn ngữ từ provider
      final langCode = context.read<LanguageProvider>().currentLocale.languageCode;
      Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(initialCategory, langCode);
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      final categoryKey = _categories.values.elementAt(_tabController.index);
      // Lấy ngôn ngữ từ provider
      final langCode = context.read<LanguageProvider>().currentLocale.languageCode;
      Provider.of<NewsProvider>(context, listen: false)
          .fetchNewsByCategory(categoryKey, langCode);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection); // Xóa listener
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5. Lấy l10n
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                l10n.appName, // <-- 6. SỬA ĐỔI
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
              // 7. Dùng _categories đã được cập nhật
              tabs: _categories.keys.map((String key) {
                return Tab(text: key);
              }).toList(),
              // Xóa hàm onTap vì đã xử lý bằng _handleTabSelection
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading && newsProvider.newsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (newsProvider.errorMessage != null && newsProvider.newsList.isEmpty) {
            // <-- 8. SỬA ĐỔI
            return Center(child: Text(l10n.errorFetchingData(newsProvider.errorMessage!)));
          }

          // ... (Phần body ListView.builder giữ nguyên) ...
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