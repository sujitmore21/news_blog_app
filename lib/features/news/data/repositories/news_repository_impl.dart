import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import '../models/news_article_model.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

/// News repository implementation
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NewsArticle>>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final articles = await remoteDataSource.getTopHeadlines(
        country: country,
        category: category,
        page: page,
        pageSize: pageSize,
      );

      print('Repository: Received ${articles.length} articles from remote');

      if (articles.isEmpty) {
        print('Warning: No articles received from remote data source');
      }

      // Cache articles for offline access (don't fail if caching fails)
      try {
        await localDataSource.cacheArticles(articles);
      } catch (cacheError) {
        print('Warning: Failed to cache articles: $cacheError');
        // Continue even if caching fails
      }

      final entities = articles.map((model) => model.toEntity()).toList();
      print('Repository: Returning ${entities.length} article entities');
      return Right(entities);
    } catch (e, stackTrace) {
      print('Error in getTopHeadlines: $e');
      print('Stack trace: $stackTrace');
      // Try to get cached data if network fails
      try {
        final cachedArticles = await localDataSource.getCachedArticles();
        print('Using ${cachedArticles.length} cached articles');
        return Right(cachedArticles.map((model) => model.toEntity()).toList());
      } catch (cacheError) {
        print('Cache error: $cacheError');
        return Left(ServerFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsArticle>>> getEverything({
    String? query,
    String? language,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final articles = await remoteDataSource.getEverything(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      );

      // Cache articles for offline access
      await localDataSource.cacheArticles(articles);

      return Right(articles.map((model) => model.toEntity()).toList());
    } catch (e) {
      // Try to get cached data if network fails
      try {
        final cachedArticles = await localDataSource.getCachedArticles();
        return Right(cachedArticles.map((model) => model.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsArticle>>> getNewsByCategory({
    required String category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final articles = await remoteDataSource.getNewsByCategory(
        category: category,
        page: page,
        pageSize: pageSize,
      );

      // Cache articles for offline access
      await localDataSource.cacheArticles(articles);

      return Right(articles.map((model) => model.toEntity()).toList());
    } catch (e) {
      // Try to get cached data if network fails
      try {
        final cachedArticles = await localDataSource.getCachedArticles();
        return Right(cachedArticles.map((model) => model.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsArticle>>> getBookmarkedArticles() async {
    try {
      final articles = await localDataSource.getBookmarkedArticles();
      return Right(articles.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookmarkArticle(String articleId) async {
    try {
      await localDataSource.bookmarkArticle(articleId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String articleId) async {
    try {
      await localDataSource.removeBookmark(articleId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isArticleBookmarked(String articleId) async {
    try {
      final isBookmarked = await localDataSource.isArticleBookmarked(articleId);
      return Right(isBookmarked);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NewsArticle>>> getCachedArticles() async {
    try {
      final articles = await localDataSource.getCachedArticles();
      return Right(articles.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheArticles(
    List<NewsArticle> articles,
  ) async {
    try {
      final models = articles
          .map((article) => NewsArticleModel.fromEntity(article))
          .toList();
      await localDataSource.cacheArticles(models);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
