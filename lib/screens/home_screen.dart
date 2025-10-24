// lib/screens/home_screen.dart
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/app_drawer.dart';
import 'article_detail_screen.dart';
import '../l10n/app_localizations.dart'; // Đảm bảo đường dẫn này đúng

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, String> _categories = {};
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final l10n = AppLocalizations.of(context)!;

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

    if (newCategories.length != _categories.length) {
      _categories = newCategories;
      _tabController.dispose();
      _tabController = TabController(length: _categories.length, vsync: this);

      _tabController.addListener(_handleTabSelection);

      _fetchInitialNews();
    } else {
      _categories = newCategories;
    }
  }

  void _fetchInitialNews() {
    if (_categories.isNotEmpty) {
      final initialCategory = _categories.values.first;
      final langCode = context.read<LanguageProvider>().currentLocale.languageCode;
      Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory(initialCategory, langCode);
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      _searchController.clear();
      final categoryKey = _categories.values.elementAt(_tabController.index);
      final langCode = context.read<LanguageProvider>().currentLocale.languageCode;
      Provider.of<NewsProvider>(context, listen: false)
          .fetchNewsByCategory(categoryKey, langCode);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        // --- 1. SỬA APPBAR ---
        toolbarHeight: 60, // Giảm chiều cao vì không còn TabBar
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        title: Text( // Dùng Text đơn giản
          l10n.appName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        // --- 2. XÓA BỎ 'bottom' KHỎI APPBAR ---
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // --- 3. THANH TÌM KIẾM (GIỮ NGUYÊN) ---
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchByTitle,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).dividerColor.withAlpha(50),
              ),
              onChanged: (value) {
                newsProvider.updateSearchQuery(value);
              },
            ),
          ),

          // --- 4. THÊM TABBAR VÀO ĐÂY ---
          Container(
            color: Theme.of(context).primaryColor,
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
              tabs: _categories.keys.map((String key) {
                return Tab(text: key);
              }).toList(),
            ),
          ),

          // --- 5. DANH SÁCH BÀI VIẾT (GIỮ NGUYÊN) ---
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                final newsList = newsProvider.filteredNewsList;

                if (newsProvider.isLoading && newsList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (newsProvider.errorMessage != null && newsList.isEmpty) {
                  return Center(
                      child: Text(
                          l10n.errorFetchingData(newsProvider.errorMessage!)));
                }

                if (newsList.isEmpty) {
                  return Center(child: Text(l10n.noArticlesFound));
                }

                return ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
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
          ),
        ],
      ),
    );
  }
}