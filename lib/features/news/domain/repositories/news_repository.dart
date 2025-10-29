import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import '../entities/news_article.dart';

/// News repository interface
abstract class NewsRepository {
  /// Get top headlines
  Future<Either<Failure, List<NewsArticle>>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  });

  /// Get everything/news search
  Future<Either<Failure, List<NewsArticle>>> getEverything({
    String? query,
    String? language,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  });

  /// Get news by category
  Future<Either<Failure, List<NewsArticle>>> getNewsByCategory({
    required String category,
    int page = 1,
    int pageSize = 20,
  });

  /// Get bookmarked articles
  Future<Either<Failure, List<NewsArticle>>> getBookmarkedArticles();

  /// Bookmark an article
  Future<Either<Failure, void>> bookmarkArticle(String articleId);

  /// Remove bookmark from an article
  Future<Either<Failure, void>> removeBookmark(String articleId);

  /// Check if article is bookmarked
  Future<Either<Failure, bool>> isArticleBookmarked(String articleId);

  /// Get cached articles
  Future<Either<Failure, List<NewsArticle>>> getCachedArticles();

  /// Cache articles
  Future<Either<Failure, void>> cacheArticles(List<NewsArticle> articles);
}
