import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news_article.dart';
import '../../domain/usecases/get_top_headlines.dart';

/// News state
abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NewsInitial extends NewsState {}

/// Loading state
class NewsLoading extends NewsState {}

/// Loaded state
class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final bool hasReachedMax;
  final int currentPage;

  const NewsLoaded({
    required this.articles,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [articles, hasReachedMax, currentPage];

  NewsLoaded copyWith({
    List<NewsArticle>? articles,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return NewsLoaded(
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Error state
class NewsError extends NewsState {
  final String message;

  const NewsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Bookmark state
class BookmarkState extends NewsState {
  final bool isBookmarked;

  const BookmarkState({required this.isBookmarked});

  @override
  List<Object?> get props => [isBookmarked];
}

/// News cubit
class NewsCubit extends Cubit<NewsState> {
  final GetTopHeadlines getTopHeadlines;
  final GetEverything getEverything;
  final GetNewsByCategory getNewsByCategory;
  final GetBookmarkedArticles getBookmarkedArticles;
  final BookmarkArticle bookmarkArticle;
  final RemoveBookmark removeBookmark;
  final IsArticleBookmarked isArticleBookmarked;
  final GetCachedArticles getCachedArticles;

  NewsCubit({
    required this.getTopHeadlines,
    required this.getEverything,
    required this.getNewsByCategory,
    required this.getBookmarkedArticles,
    required this.bookmarkArticle,
    required this.removeBookmark,
    required this.isArticleBookmarked,
    required this.getCachedArticles,
  }) : super(NewsInitial());

  /// Load top headlines
  Future<void> loadTopHeadlines({
    String? country,
    String? category,
    bool refresh = false,
  }) async {
    if (refresh) {
      emit(NewsLoading());
    } else if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.hasReachedMax) return;
      emit(NewsLoading());
    } else {
      emit(NewsLoading());
    }

    final result = await getTopHeadlines(
      GetTopHeadlinesParams(
        country: country,
        category: category,
        page: refresh
            ? 1
            : (state is NewsLoaded ? (state as NewsLoaded).currentPage : 1),
      ),
    );

    result.fold(
      (failure) =>
          emit(NewsError(message: failure?.message ?? 'An error occurred')),
      (articles) {
        if (state is NewsLoaded && !refresh) {
          final currentState = state as NewsLoaded;
          final updatedArticles = [...currentState.articles, ...articles];
          emit(
            NewsLoaded(
              articles: updatedArticles,
              hasReachedMax: articles.length < 20,
              currentPage: currentState.currentPage + 1,
            ),
          );
        } else {
          emit(
            NewsLoaded(
              articles: articles,
              hasReachedMax: articles.length < 20,
              currentPage: 2,
            ),
          );
        }
      },
    );
  }

  /// Load everything/search
  Future<void> loadEverything({
    String? query,
    String? language,
    String? sortBy,
    bool refresh = false,
  }) async {
    if (refresh) {
      emit(NewsLoading());
    } else if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.hasReachedMax) return;
      emit(NewsLoading());
    } else {
      emit(NewsLoading());
    }

    final result = await getEverything(
      GetEverythingParams(
        query: query,
        language: language,
        sortBy: sortBy,
        page: refresh
            ? 1
            : (state is NewsLoaded ? (state as NewsLoaded).currentPage : 1),
      ),
    );

    result.fold(
      (failure) =>
          emit(NewsError(message: failure?.message ?? 'An error occurred')),
      (articles) {
        if (state is NewsLoaded && !refresh) {
          final currentState = state as NewsLoaded;
          final updatedArticles = [...currentState.articles, ...articles];
          emit(
            NewsLoaded(
              articles: updatedArticles,
              hasReachedMax: articles.length < 20,
              currentPage: currentState.currentPage + 1,
            ),
          );
        } else {
          emit(
            NewsLoaded(
              articles: articles,
              hasReachedMax: articles.length < 20,
              currentPage: 2,
            ),
          );
        }
      },
    );
  }

  /// Load news by category
  Future<void> loadNewsByCategory({
    required String category,
    bool refresh = false,
  }) async {
    if (refresh) {
      emit(NewsLoading());
    } else if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.hasReachedMax) return;
      emit(NewsLoading());
    } else {
      emit(NewsLoading());
    }

    final result = await getNewsByCategory(
      GetNewsByCategoryParams(
        category: category,
        page: refresh
            ? 1
            : (state is NewsLoaded ? (state as NewsLoaded).currentPage : 1),
      ),
    );

    result.fold(
      (failure) =>
          emit(NewsError(message: failure?.message ?? 'An error occurred')),
      (articles) {
        if (state is NewsLoaded && !refresh) {
          final currentState = state as NewsLoaded;
          final updatedArticles = [...currentState.articles, ...articles];
          emit(
            NewsLoaded(
              articles: updatedArticles,
              hasReachedMax: articles.length < 20,
              currentPage: currentState.currentPage + 1,
            ),
          );
        } else {
          emit(
            NewsLoaded(
              articles: articles,
              hasReachedMax: articles.length < 20,
              currentPage: 2,
            ),
          );
        }
      },
    );
  }

  /// Load bookmarked articles
  Future<void> loadBookmarkedArticles() async {
    emit(NewsLoading());

    final result = await getBookmarkedArticles();

    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(
        NewsLoaded(articles: articles, hasReachedMax: true, currentPage: 1),
      ),
    );
  }

  /// Toggle bookmark
  Future<void> toggleBookmark(String articleId) async {
    final result = await isArticleBookmarked(
      IsArticleBookmarkedParams(articleId: articleId),
    );

    result.fold((failure) => emit(NewsError(message: failure.message)), (
      isBookmarked,
    ) async {
      if (isBookmarked) {
        await removeBookmark(RemoveBookmarkParams(articleId: articleId));
      } else {
        await bookmarkArticle(BookmarkArticleParams(articleId: articleId));
      }

      // Update the article in the current state
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;
        final updatedArticles = currentState.articles.map((article) {
          if (article.id == articleId) {
            return article.copyWith(isBookmarked: !isBookmarked);
          }
          return article;
        }).toList();

        emit(
          NewsLoaded(
            articles: updatedArticles,
            hasReachedMax: currentState.hasReachedMax,
            currentPage: currentState.currentPage,
          ),
        );
      }
    });
  }

  /// Load cached articles
  Future<void> loadCachedArticles() async {
    emit(NewsLoading());

    final result = await getCachedArticles();

    result.fold(
      (failure) => emit(NewsError(message: failure.message)),
      (articles) => emit(
        NewsLoaded(articles: articles, hasReachedMax: true, currentPage: 1),
      ),
    );
  }

  /// Refresh data
  Future<void> refresh() async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.articles.isNotEmpty) {
        // Refresh with the same parameters as the last load
        await loadTopHeadlines(refresh: true);
      }
    }
  }
}
