import 'package:flutter_test/flutter_test.dart';
import 'package:news_blog_app/features/news/data/models/news_article_model.dart';

void main() {
  group('GNews API Integration Tests', () {
    test('should parse GNews API response correctly', () {
      // Sample GNews API response
      final jsonResponse = {
        'id': '330fa4d2cef6ea43f73c0cbf90e76ec6',
        'title':
            'If things in America weren\'t stupid enough, Texas is suing Tylenol maker',
        'description':
            'Texas sues Tylenol maker over unproven claim the pain medicine causes autism.',
        'content':
            'While the underlying cause or causes of autism spectrum disorder remain elusive...',
        'url':
            'https://arstechnica.com/health/2025/10/if-things-in-america-werent-stupid-enough-texas-is-suing-tylenol-maker/',
        'image':
            'https://cdn.arstechnica.net/wp-content/uploads/2025/10/GettyImages-2150327872-2560x1440.jpg',
        'publishedAt': '2025-10-28T19:12:29Z',
        'lang': 'en',
        'source': {
          'id': '344add8dabb753d03641ce9f246787ad',
          'name': 'Ars Technica',
          'url': 'https://arstechnica.com',
        },
      };

      // Test parsing
      final article = NewsArticleModel.fromJson(jsonResponse);

      // Verify parsed data
      expect(article.id, '330fa4d2cef6ea43f73c0cbf90e76ec6');
      expect(
        article.title,
        'If things in America weren\'t stupid enough, Texas is suing Tylenol maker',
      );
      expect(
        article.description,
        'Texas sues Tylenol maker over unproven claim the pain medicine causes autism.',
      );
      expect(
        article.url,
        'https://arstechnica.com/health/2025/10/if-things-in-america-werent-stupid-enough-texas-is-suing-tylenol-maker/',
      );
      expect(
        article.imageUrl,
        'https://cdn.arstechnica.net/wp-content/uploads/2025/10/GettyImages-2150327872-2560x1440.jpg',
      );
      expect(article.publishedAt, '2025-10-28T19:12:29Z');
      expect(article.source, 'Ars Technica');
      expect(article.author, ''); // GNews doesn't provide author
      expect(article.categories, []); // Will be set based on category parameter
    });

    test('should handle missing fields gracefully', () {
      // Response with missing fields
      final jsonResponse = {
        'id': 'test-id',
        'title': 'Test Title',
        // Missing other fields
      };

      final article = NewsArticleModel.fromJson(jsonResponse);

      expect(article.id, 'test-id');
      expect(article.title, 'Test Title');
      expect(article.description, '');
      expect(article.content, '');
      expect(article.url, '');
      expect(article.imageUrl, '');
      expect(article.publishedAt, '');
      expect(article.source, '');
      expect(article.author, '');
      expect(article.categories, []);
    });

    test('should handle null source gracefully', () {
      final jsonResponse = {
        'id': 'test-id',
        'title': 'Test Title',
        'source': null,
      };

      final article = NewsArticleModel.fromJson(jsonResponse);

      expect(article.source, '');
    });
  });
}
