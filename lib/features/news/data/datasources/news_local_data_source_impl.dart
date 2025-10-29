import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_article_model.dart';
import 'news_remote_data_source.dart';

/// News local data source implementation
class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'cached_articles';
  static const String _bookmarksKey = 'bookmarked_articles';

  NewsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<NewsArticleModel>> getCachedArticles() async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('news_cache');
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get cached articles: $e');
    }
  }

  @override
  Future<void> cacheArticles(List<NewsArticleModel> articles) async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('news_cache');
      await box.clear();

      for (int i = 0; i < articles.length; i++) {
        await box.put(i.toString(), articles[i]);
      }
    } catch (e) {
      throw Exception('Failed to cache articles: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getBookmarkedArticles() async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('bookmarks');
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get bookmarked articles: $e');
    }
  }

  @override
  Future<void> bookmarkArticle(String articleId) async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('bookmarks');
      final cacheBox = await Hive.openBox<NewsArticleModel>('news_cache');

      // Find the article in cache
      NewsArticleModel? article;
      for (var cachedArticle in cacheBox.values) {
        if (cachedArticle.id == articleId) {
          article = cachedArticle;
          break;
        }
      }

      if (article != null) {
        await box.put(articleId, article);
      }
    } catch (e) {
      throw Exception('Failed to bookmark article: $e');
    }
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('bookmarks');
      await box.delete(articleId);
    } catch (e) {
      throw Exception('Failed to remove bookmark: $e');
    }
  }

  @override
  Future<bool> isArticleBookmarked(String articleId) async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('bookmarks');
      return box.containsKey(articleId);
    } catch (e) {
      throw Exception('Failed to check bookmark status: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<NewsArticleModel>('news_cache');
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
}
