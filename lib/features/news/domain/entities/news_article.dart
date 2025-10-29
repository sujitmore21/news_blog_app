import 'package:equatable/equatable.dart';

/// News article entity
class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String description;
  final String content;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String source;
  final String author;
  final List<String> categories;
  final bool isBookmarked;
  final int readTime; // in minutes

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    required this.author,
    required this.categories,
    this.isBookmarked = false,
    this.readTime = 5,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    content,
    url,
    imageUrl,
    publishedAt,
    source,
    author,
    categories,
    isBookmarked,
    readTime,
  ];

  NewsArticle copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? url,
    String? imageUrl,
    String? publishedAt,
    String? source,
    String? author,
    List<String>? categories,
    bool? isBookmarked,
    int? readTime,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      source: source ?? this.source,
      author: author ?? this.author,
      categories: categories ?? this.categories,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      readTime: readTime ?? this.readTime,
    );
  }
}
