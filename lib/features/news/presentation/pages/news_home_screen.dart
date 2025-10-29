import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/news_cubit.dart';
import '../widgets/news_article_card.dart';
import '../../../../shared/widgets/custom_widgets.dart';
import '../../domain/entities/news_article.dart';
import 'news_search_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

/// News home screen
class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  late NewsCubit _newsCubit;
  final List<String> _categories = [
    'general',
    'world',
    'nation',
    'business',
    'technology',
    'entertainment',
    'sports',
    'science',
    'health',
  ];
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    _newsCubit = sl<NewsCubit>();
    _loadNews();
  }

  void _loadNews() {
    _newsCubit.loadTopHeadlines(category: _selectedCategory);
  }

  void _loadMore() {
    _newsCubit.loadTopHeadlines(category: _selectedCategory);
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _newsCubit.loadTopHeadlines(category: category, refresh: true);
  }

  void _onArticleTap(NewsArticle article) {
    // Navigate to article detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(article: article),
      ),
    );
  }

  void _onBookmarkTap(NewsArticle article) {
    _newsCubit.toggleBookmark(article.id);
  }

  int _currentBottomNavIndex = 1; // Home is selected by default

  String _formatCategoryName(String category) {
    final categoryMap = {
      'general': 'My Feed',
      'business': 'Finance',
      'technology': 'Tech',
      'science': 'Science',
      'world': 'World',
      'nation': 'Nation',
      'entertainment': 'Entertainment',
      'sports': 'Sports',
      'health': 'Health',
    };
    return categoryMap[category] ??
        category[0].toUpperCase() + category.substring(1);
  }

  // Floating card widget (currently not used, can be enabled if needed)
  // ignore: unused_element
  Widget _buildFloatingCard(NewsArticle article) {
    return GestureDetector(
      onTap: () => _onArticleTap(article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF2A2A2A), const Color(0xFF1E1E1E)],
              ),
            ),
            child: Row(
              children: [
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Continue Reading',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.description.isNotEmpty
                            ? article.description
                            : article.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2196F3).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Read More',
                                  style: TextStyle(
                                    color: Color(0xFF2196F3),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: const Color(0xFF2196F3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Arrow icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF2196F3),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 0;
              });
            },
            icon: Icon(
              Icons.search,
              color: _currentBottomNavIndex == 0
                  ? const Color(0xFF2196F3)
                  : Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 1;
              });
            },
            icon: Icon(
              Icons.home,
              color: _currentBottomNavIndex == 1
                  ? const Color(0xFF2196F3)
                  : Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 2;
              });
            },
            icon: Icon(
              Icons.person,
              color: _currentBottomNavIndex == 2
                  ? const Color(0xFF2196F3)
                  : Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          // Category chips - NewsHub style with blue underline
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: GestureDetector(
                    onTap: () => _onCategorySelected(category),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatCategoryName(category),
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF2196F3) // Blue for selected
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (isSelected)
                          Container(
                            height: 3,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3), // Blue underline
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )
                        else
                          const SizedBox(height: 3),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // News list
          Expanded(
            child: BlocProvider(
              create: (context) => _newsCubit,
              child: BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is NewsInitial || state is NewsLoading) {
                    return const CustomLoadingWidget(
                      message: 'Loading news...',
                    );
                  } else if (state is NewsError) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: _loadNews,
                    );
                  } else if (state is NewsLoaded) {
                    return NewsArticleList(
                      articles: state.articles,
                      isLoading: false,
                      hasReachedMax: state.hasReachedMax,
                      onLoadMore: _loadMore,
                      onArticleTap: _onArticleTap,
                      onBookmarkTap: _onBookmarkTap,
                    );
                  }
                  return const CustomEmptyWidget(
                    message: 'No news available',
                    icon: Icons.article_outlined,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: [
          const NewsSearchScreen(),
          _buildHomeContent(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

/// News detail screen
class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondaryColor = isDark
        ? const Color(0xFFB0B0B0)
        : Colors.grey[600];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            onPressed: () {
              // Toggle bookmark
            },
            icon: Icon(
              article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            if (article.categories.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  article.categories.first.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            // Title
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            // Image
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: article.imageUrl,
                  width: double.infinity,
                  height: 250,
                ),
              ),
            const SizedBox(height: 20),
            // Source and read time
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.source,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.access_time, size: 14, color: textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  '${article.readTime} min read',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: textSecondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Description
            Text(
              article.description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
            // Content
            Text(
              article.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textSecondaryColor,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bookmarked news screen
class BookmarkedNewsScreen extends StatefulWidget {
  const BookmarkedNewsScreen({super.key});

  @override
  State<BookmarkedNewsScreen> createState() => _BookmarkedNewsScreenState();
}

class _BookmarkedNewsScreenState extends State<BookmarkedNewsScreen> {
  late NewsCubit _newsCubit;

  @override
  void initState() {
    super.initState();
    _newsCubit = sl<NewsCubit>();
    _newsCubit.loadBookmarkedArticles();
  }

  void _onBookmarkTap(NewsArticle article) {
    _newsCubit.toggleBookmark(article.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Articles')),
      body: BlocProvider(
        create: (context) => _newsCubit,
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const CustomLoadingWidget(message: 'Loading bookmarks...');
            } else if (state is NewsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _newsCubit.loadBookmarkedArticles(),
              );
            } else if (state is NewsLoaded) {
              return NewsArticleList(
                articles: state.articles,
                onBookmarkTap: _onBookmarkTap,
              );
            }
            return const CustomEmptyWidget(
              message: 'No bookmarked articles',
              icon: Icons.bookmark_border,
            );
          },
        ),
      ),
    );
  }
}
