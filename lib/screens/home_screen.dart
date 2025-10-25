import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../providers/auth_provider.dart'; // Thêm: Cần để kiểm tra đăng nhập
import '../widgets/app_drawer.dart';
import 'article_detail_screen.dart'; // Giữ: Màn hình chi tiết (API)
import 'article_detail_admin_content_screen.dart'; // Thêm: Màn hình chi tiết (Admin)
import 'auth_screen.dart'; // Thêm: Cần để điều hướng đăng nhập
import '../models/display_article.dart'; // Thêm: Model thống nhất
import '../l10n/app_localizations.dart';

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

    // TODO: Cân nhắc chuyển map này ra file utils/categories.dart
    // để dùng chung với Admin Edit Screen
    final newCategories = {
      l10n.categoryTop: 'top',
      l10n.categoryPolitics: 'politics',
      l10n.categoryWorld: 'world',
      l10n.categoryBusiness: 'business',
      l10n.categoryScience: 'science',
      l10n.categoryEntertainment: 'entertainment',
      l10n.categorySports: 'sports',
      l10n.categoryEntertainment2: 'entertainment', // Có vẻ bị trùng?
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
      // Cập nhật lại key (ngôn ngữ) dù length không đổi
      _categories = newCategories;
    }
  }

  void _fetchInitialNews() {
    if (_categories.isNotEmpty) {
      final initialCategory = _categories.values.first;
      final langCode =
          context.read<LanguageProvider>().currentLocale.languageCode;
      Provider.of<NewsProvider>(context, listen: false)
          .fetchNewsByCategory(initialCategory, langCode);
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      _searchController.clear();
      final categoryKey = _categories.values.elementAt(_tabController.index);
      final langCode =
          context.read<LanguageProvider>().currentLocale.languageCode;
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

  // --- THÊM HÀM MỚI ---
  // Hiển thị dialog yêu cầu đăng nhập
  void _showLoginRequiredDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.loginRequiredTitle),
        content: Text(l10n.loginRequiredMessage),
        actions: [
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text(l10n.login),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
  // --- KẾT THÚC HÀM MỚI ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    // Thêm AuthProvider để kiểm tra đăng nhập cho các nút bấm
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing,
        title: Text(
          l10n.appName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Ô Tìm kiếm
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

          // TabBar Thể loại
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

          // Danh sách Tin tức
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, child) {
                // SỬ DỤNG DANH SÁCH ĐÃ GỘP
                final List<DisplayArticle> newsList =
                    newsProvider.filteredNewsList;

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
                    final article = newsList[index]; // article là DisplayArticle

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // InkWell chỉ bọc hình ảnh và tiêu đề
                          InkWell(
                            onTap: () {
                              // --- ĐIỀU HƯỚNG THÔNG MINH ---
                              if (article.isFromAdmin) {
                                // Nếu là tin Admin, đi đến màn hình chi tiết Admin
                                Navigator.pushNamed(
                                  context,
                                  ArticleDetailAdminContentScreen.routeName,
                                  arguments: article,
                                );
                              } else {
                                // Nếu là tin API, đi đến màn hình chi tiết API (cũ)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailScreen(
                                      articleUrl: article.articleUrl,
                                      articleTitle: article.title,
                                      // Thêm articleId để dùng cho Lưu/Bình luận
                                      articleId: article.id,
                                    ),
                                  ),
                                );
                              }
                              // --- KẾT THÚC ĐIỀU HƯỚNG ---
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hình ảnh
                                if (article.imageUrl != null &&
                                    article.imageUrl!.isNotEmpty)
                                  Image.network(
                                    article.imageUrl!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const SizedBox(
                                        height: 200,
                                        child: Icon(
                                            Icons.broken_image_outlined,
                                            size: 50,
                                            color: Colors.grey),
                                      );
                                    },
                                  ),
                                // Tiêu đề và Nguồn
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        article.sourceName,
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

                          // --- DẢI NÚT LƯU VÀ BÌNH LUẬN ---
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.bookmark_border),
                                  tooltip:
                                  l10n.savedArticles, // Dùng lại l10n
                                  onPressed: () {
                                    if (!auth.isAuth) {
                                      _showLoginRequiredDialog(context);
                                      return;
                                    }
                                    // TODO: Logic lưu bài viết (sử dụng article.id)
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'TODO: Xử lý lưu bài viết')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.comment_outlined),
                                  tooltip: 'Bình luận', // TODO: Thêm vào l10n
                                  onPressed: () {
                                    if (!auth.isAuth) {
                                      _showLoginRequiredDialog(context);
                                      return;
                                    }
                                    // TODO: Logic bình luận (sử dụng article.id)
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'TODO: Xử lý bình luận')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // --- KẾT THÚC DẢI NÚT ---
                        ],
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

