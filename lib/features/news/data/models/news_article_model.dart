import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/news_article.dart';

part 'news_article_model.g.dart';

/// News article data model
@JsonSerializable()
class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.source,
    required super.author,
    required super.categories,
    super.isBookmarked = false,
    super.readTime = 5,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    // Handle GNews API response structure
    final source = json['source'] as Map<String, dynamic>?;
    return NewsArticleModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      content: json['content'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      source: source?['name'] as String? ?? '',
      author: '', // GNews doesn't provide author info
      categories: [], // Will be set based on category parameter
      isBookmarked: false,
      readTime: 5,
    );
  }

  Map<String, dynamic> toJson() => _$NewsArticleModelToJson(this);

  factory NewsArticleModel.fromEntity(NewsArticle article) {
    return NewsArticleModel(
      id: article.id,
      title: article.title,
      description: article.description,
      content: article.content,
      url: article.url,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      source: article.source,
      author: article.author,
      categories: article.categories,
      isBookmarked: article.isBookmarked,
      readTime: article.readTime,
    );
  }

  NewsArticle toEntity() {
    return NewsArticle(
      id: id,
      title: title,
      description: description,
      content: content,
      url: url,
      imageUrl: imageUrl,
      publishedAt: publishedAt,
      source: source,
      author: author,
      categories: categories,
      isBookmarked: isBookmarked,
      readTime: readTime,
    );
  }
}
