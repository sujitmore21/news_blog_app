import 'package:dio/dio.dart';
import 'package:news_blog_app/core/network/network_client.dart';
import '../models/news_article_model.dart';
import 'news_remote_data_source.dart';

/// News remote data source implementation
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final NetworkClient networkClient;

  NewsRemoteDataSourceImpl(this.networkClient);

  @override
  Future<List<NewsArticleModel>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // GNews requires at least one of category or country
      // Default to 'general' category if neither is provided
      final finalCategory = category ?? (country == null ? 'general' : null);

      final response = await NetworkClient.client.getTopHeadlines(
        finalCategory,
        country,
        'en', // language
        pageSize,
        page,
      );

      if (response['articles'] != null) {
        final List<dynamic> articlesJson = response['articles'];
        print('Parsing ${articlesJson.length} articles');
        final articles = <NewsArticleModel>[];
        for (final json in articlesJson) {
          try {
            final article = NewsArticleModel.fromJson(
              json as Map<String, dynamic>,
            );
            // Add category to the article
            final finalCategory =
                category ?? (country == null ? 'general' : null);
            if (finalCategory != null) {
              articles.add(
                NewsArticleModel(
                  id: article.id,
                  title: article.title,
                  description: article.description,
                  content: article.content,
                  url: article.url,
                  imageUrl: article.imageUrl,
                  publishedAt: article.publishedAt,
                  source: article.source,
                  author: article.author,
                  categories: [finalCategory],
                  isBookmarked: article.isBookmarked,
                  readTime: article.readTime,
                ),
              );
            } else {
              articles.add(article);
            }
          } catch (e, stackTrace) {
            print('Error parsing article: $e');
            print('Stack trace: $stackTrace');
            print('Article JSON: $json');
            // Continue with next article instead of failing completely
          }
        }
        print('Successfully parsed ${articles.length} articles');
        return articles;
      } else {
        throw Exception('Failed to load top headlines: articles field is null');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getEverything({
    String? query,
    String? language,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await NetworkClient.client.searchNews(
        query,
        language ?? 'en',
        null, // country
        pageSize,
        page,
        null, // from date
        null, // to date
        sortBy,
      );

      if (response['articles'] != null) {
        final List<dynamic> articlesJson = response['articles'];
        return articlesJson
            .map((json) => NewsArticleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<NewsArticleModel>> getNewsByCategory({
    required String category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await NetworkClient.client.getTopHeadlines(
        category,
        null, // country
        'en', // language
        pageSize,
        page,
      );

      if (response['articles'] != null) {
        final List<dynamic> articlesJson = response['articles'];
        print(
          'Parsing ${articlesJson.length} articles for category: $category',
        );
        final articles = <NewsArticleModel>[];
        for (final json in articlesJson) {
          try {
            final article = NewsArticleModel.fromJson(
              json as Map<String, dynamic>,
            );
            articles.add(
              NewsArticleModel(
                id: article.id,
                title: article.title,
                description: article.description,
                content: article.content,
                url: article.url,
                imageUrl: article.imageUrl,
                publishedAt: article.publishedAt,
                source: article.source,
                author: article.author,
                categories: [category],
                isBookmarked: article.isBookmarked,
                readTime: article.readTime,
              ),
            );
          } catch (e, stackTrace) {
            print('Error parsing article: $e');
            print('Stack trace: $stackTrace');
            print('Article JSON: $json');
            // Continue with next article instead of failing completely
          }
        }
        print('Successfully parsed ${articles.length} articles');
        return articles;
      } else {
        throw Exception(
          'Failed to load category articles: articles field is null',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
