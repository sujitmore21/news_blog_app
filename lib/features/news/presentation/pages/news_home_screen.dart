import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/news_cubit.dart';
import '../widgets/news_article_card.dart';
import '../../../../shared/widgets/custom_widgets.dart';
import '../../domain/entities/news_article.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarkedNewsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: NewsCategoryChip(
                    category: category,
                    isSelected: category == _selectedCategory,
                    onTap: () => _onCategorySelected(category),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _loadNews,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

/// News detail screen
class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomImageWidget(
              imageUrl: article.imageUrl,
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Source: ${article.source}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),
                Text(
                  '${article.readTime} min read',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              article.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              article.content,
              style: Theme.of(context).textTheme.bodyMedium,
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
