import 'package:dartz/dartz.dart';
import '../models/news_article_model.dart';

/// Remote data source for news
abstract class NewsRemoteDataSource {
  /// Get top headlines from API
  Future<List<NewsArticleModel>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  });

  /// Get everything/news search from API
  Future<List<NewsArticleModel>> getEverything({
    String? query,
    String? language,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  });

  /// Get news by category from API
  Future<List<NewsArticleModel>> getNewsByCategory({
    required String category,
    int page = 1,
    int pageSize = 20,
  });
}

/// Local data source for news
abstract class NewsLocalDataSource {
  /// Get cached articles
  Future<List<NewsArticleModel>> getCachedArticles();

  /// Cache articles
  Future<void> cacheArticles(List<NewsArticleModel> articles);

  /// Get bookmarked articles
  Future<List<NewsArticleModel>> getBookmarkedArticles();

  /// Bookmark an article
  Future<void> bookmarkArticle(String articleId);

  /// Remove bookmark from an article
  Future<void> removeBookmark(String articleId);

  /// Check if article is bookmarked
  Future<bool> isArticleBookmarked(String articleId);

  /// Clear all cached data
  Future<void> clearCache();
}
