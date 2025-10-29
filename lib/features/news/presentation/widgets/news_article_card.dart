import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/custom_widgets.dart';
import '../../domain/entities/news_article.dart';

/// News article card widget
class NewsArticleCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;
  final bool showBookmarkButton;

  const NewsArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
    this.showBookmarkButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${article.readTime} min read',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(article.publishedAt),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CustomImageWidget(
                          imageUrl: article.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (showBookmarkButton) ...[
                          const SizedBox(height: 8),
                          IconButton(
                            onPressed: onBookmark,
                            icon: Icon(
                              article.isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: article.isBookmarked
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Source: ${article.source}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  if (article.author.isNotEmpty)
                    Text(
                      'By ${article.author}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

/// News article list widget
class NewsArticleList extends StatelessWidget {
  final List<NewsArticle> articles;
  final bool isLoading;
  final bool hasReachedMax;
  final VoidCallback? onLoadMore;
  final Function(NewsArticle)? onArticleTap;
  final Function(NewsArticle)? onBookmarkTap;

  const NewsArticleList({
    super.key,
    required this.articles,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.onLoadMore,
    this.onArticleTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty && !isLoading) {
      return const CustomEmptyWidget(
        message: 'No articles found',
        icon: Icons.article_outlined,
      );
    }

    return ListView.builder(
      itemCount: articles.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == articles.length) {
          if (isLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (!hasReachedMax && onLoadMore != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onLoadMore!();
            });
            return const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        }

        final article = articles[index];
        return NewsArticleCard(
          article: article,
          onTap: () => onArticleTap?.call(article),
          onBookmark: () => onBookmarkTap?.call(article),
        );
      },
    );
  }
}

/// News category chip widget
class NewsCategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback? onTap;

  const NewsCategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
        child: Text(
          category.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
