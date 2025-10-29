import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/news_cubit.dart';
import '../widgets/news_article_card.dart';
import '../../../../shared/widgets/custom_widgets.dart';
import '../../domain/entities/news_article.dart';

/// News search screen
class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({super.key});

  @override
  State<NewsSearchScreen> createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  late NewsCubit _newsCubit;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _newsCubit = sl<NewsCubit>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      _newsCubit.loadEverything(
        query: query.trim(),
        language: 'en',
        refresh: true,
      );
    }
  }

  void _onArticleTap(NewsArticle article) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search news...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            onSubmitted: _performSearch,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            TextButton(
              onPressed: () => _performSearch(_searchController.text),
              child: const Text(
                'Search',
                style: TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _newsCubit,
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsInitial) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey[600]),
                    const SizedBox(height: 16),
                    Text(
                      'Search for news articles',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter keywords to find articles',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              );
            } else if (state is NewsLoading) {
              return const CustomLoadingWidget(message: 'Searching...');
            } else if (state is NewsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => _performSearch(_searchController.text),
              );
            } else if (state is NewsLoaded) {
              if (state.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching with different keywords',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }
              return NewsArticleList(
                articles: state.articles,
                isLoading: false,
                hasReachedMax: state.hasReachedMax,
                onArticleTap: _onArticleTap,
                onBookmarkTap: _onBookmarkTap,
              );
            }
            return const CustomEmptyWidget(
              message: 'Start searching for news',
              icon: Icons.search,
            );
          },
        ),
      ),
    );
  }
}

/// News detail screen (imported from news_home_screen)
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
