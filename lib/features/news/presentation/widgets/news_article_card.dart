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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondaryColor = isDark
        ? const Color(0xFFB0B0B0)
        : Colors.grey[600];

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with overlapping badge
              if (article.imageUrl.isNotEmpty)
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 280,
                      child: CustomImageWidget(
                        imageUrl: article.imageUrl,
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // "NewsHub" badge overlapping image
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'NewsHub',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.grid_view,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              // Content padding
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title - Large and bold
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            fontSize: 22,
                          ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Article body/description
                    Text(
                      article.description.isNotEmpty
                          ? article.description
                          : article.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        height: 1.6,
                        fontSize: 16,
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Metadata: "few hours ago | Author | Source"
                    Text(
                      _formatMetadata(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMetadata() {
    final dateStr = _formatDate(article.publishedAt);
    final author = article.author.isNotEmpty ? article.author : 'Staff';
    return '$dateStr | $author | ${article.source}';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      return 'few hours ago';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : (isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade300),
            width: 1,
          ),
        ),
        child: Text(
          category.toUpperCase(),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFFB0B0B0) : Colors.black54),
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
