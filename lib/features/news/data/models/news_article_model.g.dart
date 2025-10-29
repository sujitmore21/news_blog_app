// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsArticleModel _$NewsArticleModelFromJson(Map<String, dynamic> json) =>
    NewsArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String,
      publishedAt: json['publishedAt'] as String,
      source: json['source'] as String,
      author: json['author'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      readTime: (json['readTime'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$NewsArticleModelToJson(NewsArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'url': instance.url,
      'imageUrl': instance.imageUrl,
      'publishedAt': instance.publishedAt,
      'source': instance.source,
      'author': instance.author,
      'categories': instance.categories,
      'isBookmarked': instance.isBookmarked,
      'readTime': instance.readTime,
    };
