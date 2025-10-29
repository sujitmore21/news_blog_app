import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import 'package:news_blog_app/core/usecase.dart';
import 'package:news_blog_app/features/news/domain/entities/news_article.dart';
import 'package:news_blog_app/features/news/domain/repositories/news_repository.dart';

/// Get top headlines use case
class GetTopHeadlines
    implements UseCase<List<NewsArticle>, GetTopHeadlinesParams> {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call(
    GetTopHeadlinesParams params,
  ) async {
    return await repository.getTopHeadlines(
      country: params.country,
      category: params.category,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

/// Get everything/news search use case
class GetEverything implements UseCase<List<NewsArticle>, GetEverythingParams> {
  final NewsRepository repository;

  GetEverything(this.repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call(
    GetEverythingParams params,
  ) async {
    return await repository.getEverything(
      query: params.query,
      language: params.language,
      sortBy: params.sortBy,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

/// Get news by category use case
class GetNewsByCategory
    implements UseCase<List<NewsArticle>, GetNewsByCategoryParams> {
  final NewsRepository repository;

  GetNewsByCategory(this.repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call(
    GetNewsByCategoryParams params,
  ) async {
    return await repository.getNewsByCategory(
      category: params.category,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}

/// Get bookmarked articles use case
class GetBookmarkedArticles implements UseCaseNoParams<List<NewsArticle>> {
  final NewsRepository repository;

  GetBookmarkedArticles(this.repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call() async {
    return await repository.getBookmarkedArticles();
  }
}

/// Bookmark article use case
class BookmarkArticle implements UseCase<void, BookmarkArticleParams> {
  final NewsRepository repository;

  BookmarkArticle(this.repository);

  @override
  Future<Either<Failure, void>> call(BookmarkArticleParams params) async {
    return await repository.bookmarkArticle(params.articleId);
  }
}

/// Remove bookmark use case
class RemoveBookmark implements UseCase<void, RemoveBookmarkParams> {
  final NewsRepository repository;

  RemoveBookmark(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveBookmarkParams params) async {
    return await repository.removeBookmark(params.articleId);
  }
}

/// Check if article is bookmarked use case
class IsArticleBookmarked implements UseCase<bool, IsArticleBookmarkedParams> {
  final NewsRepository repository;

  IsArticleBookmarked(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsArticleBookmarkedParams params) async {
    return await repository.isArticleBookmarked(params.articleId);
  }
}

/// Get cached articles use case
class GetCachedArticles implements UseCaseNoParams<List<NewsArticle>> {
  final NewsRepository repository;

  GetCachedArticles(this.repository);

  @override
  Future<Either<Failure, List<NewsArticle>>> call() async {
    return await repository.getCachedArticles();
  }
}

/// Parameters classes
class GetTopHeadlinesParams extends Params {
  final String? country;
  final String? category;
  final int page;
  final int pageSize;

  const GetTopHeadlinesParams({
    this.country,
    this.category,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [country, category, page, pageSize];
}

class GetEverythingParams extends Params {
  final String? query;
  final String? language;
  final String? sortBy;
  final int page;
  final int pageSize;

  const GetEverythingParams({
    this.query,
    this.language,
    this.sortBy,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [query, language, sortBy, page, pageSize];
}

class GetNewsByCategoryParams extends Params {
  final String category;
  final int page;
  final int pageSize;

  const GetNewsByCategoryParams({
    required this.category,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [category, page, pageSize];
}

class BookmarkArticleParams extends Params {
  final String articleId;

  const BookmarkArticleParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}

class RemoveBookmarkParams extends Params {
  final String articleId;

  const RemoveBookmarkParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}

class IsArticleBookmarkedParams extends Params {
  final String articleId;

  const IsArticleBookmarkedParams({required this.articleId});

  @override
  List<Object?> get props => [articleId];
}
