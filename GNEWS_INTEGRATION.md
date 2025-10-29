# GNews API Integration Guide

## Overview
The News Blog App has been updated to use the GNews API instead of NewsAPI. GNews provides real-time news data with powerful search capabilities and category-based filtering.

## API Endpoints

### 1. Top Headlines Endpoint
**URL:** `https://gnews.io/api/v4/top-headlines`

**Parameters:**
- `category`: News category (general, world, nation, business, technology, entertainment, sports, science, health)
- `country`: Country code (e.g., 'us', 'gb', 'ca')
- `lang`: Language code (e.g., 'en', 'es', 'fr')
- `max`: Maximum number of articles to return (1-100)
- `page`: Page number for pagination
- `apikey`: Your GNews API key

**Example Request:**
```
GET https://gnews.io/api/v4/top-headlines?category=technology&lang=en&max=20&page=1&apikey=YOUR_API_KEY
```

### 2. Search Endpoint
**URL:** `https://gnews.io/api/v4/search`

**Parameters:**
- `q`: Search query/keywords
- `lang`: Language code
- `country`: Country code
- `max`: Maximum number of articles
- `page`: Page number
- `from`: Start date (YYYY-MM-DD)
- `to`: End date (YYYY-MM-DD)
- `sortby`: Sort by relevance or publishedAt
- `apikey`: Your GNews API key

**Example Request:**
```
GET https://gnews.io/api/v4/search?q=artificial%20intelligence&lang=en&max=20&page=1&apikey=YOUR_API_KEY
```

## Response Structure

```json
{
  "totalArticles": 320340,
  "articles": [
    {
      "id": "330fa4d2cef6ea43f73c0cbf90e76ec6",
      "title": "Article Title",
      "description": "Article description",
      "content": "Full article content...",
      "url": "https://example.com/article",
      "image": "https://example.com/image.jpg",
      "publishedAt": "2025-10-28T19:12:29Z",
      "lang": "en",
      "source": {
        "id": "344add8dabb753d03641ce9f246787ad",
        "name": "Source Name",
        "url": "https://source.com"
      }
    }
  ]
}
```

## Available Categories

GNews API supports the following categories:

1. **general** - General news
2. **world** - World news
3. **nation** - National news
4. **business** - Business and finance
5. **technology** - Technology news
6. **entertainment** - Entertainment news
7. **sports** - Sports news
8. **science** - Science news
9. **health** - Health news

## Configuration

### 1. API Key Setup
Update your API key in `lib/core/constants/app_constants.dart`:

```dart
static const String apiKey = 'YOUR_GNEWS_API_KEY';
```

### 2. Base URL
The base URL is already configured:
```dart
static const String baseUrl = 'https://gnews.io/api/v4';
```

## Implementation Details

### Data Model Updates
The `NewsArticleModel` has been updated to handle GNews API response structure:

```dart
factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
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
```

### Network Client Updates
The REST client has been updated with GNews-specific endpoints:

```dart
@GET('/top-headlines')
Future<Map<String, dynamic>> getTopHeadlines(
  @Query('category') String? category,
  @Query('country') String? country,
  @Query('lang') String? language,
  @Query('max') int max,
  @Query('page') int page,
);

@GET('/search')
Future<Map<String, dynamic>> searchNews(
  @Query('q') String? query,
  @Query('lang') String? language,
  @Query('country') String? country,
  @Query('max') int max,
  @Query('page') int page,
  @Query('from') String? from,
  @Query('to') String? to,
  @Query('sortby') String? sortBy,
);
```

## Features Supported

### 1. Category-based News
- Users can filter news by category
- Real-time updates based on Google News rankings
- Support for all 9 GNews categories

### 2. Search Functionality
- Keyword-based news search
- Advanced filtering options
- Date range filtering
- Language and country targeting

### 3. Pagination
- Efficient pagination support
- Configurable page size
- Infinite scroll implementation

### 4. Offline Support
- Local caching with Hive
- Offline article reading
- Bookmark functionality

## API Limits and Considerations

### Free Plan Limitations
- 12-hour delay for real-time news
- Limited requests per day
- Basic features only

### Paid Plan Benefits
- Real-time news data
- Higher request limits
- Advanced features
- Priority support

## Error Handling

The app includes comprehensive error handling for:

1. **Network Errors**: Connection timeouts, no internet
2. **API Errors**: Invalid API key, rate limiting
3. **Data Errors**: Malformed responses, missing fields
4. **Cache Errors**: Local storage issues

## Testing

### 1. Unit Tests
Test the data model parsing:
```dart
test('should parse GNews API response correctly', () {
  // Test implementation
});
```

### 2. Integration Tests
Test API integration:
```dart
test('should fetch top headlines from GNews API', () async {
  // Test implementation
});
```

## Migration from NewsAPI

The following changes were made during migration:

1. **API Endpoints**: Updated to GNews endpoints
2. **Response Structure**: Adapted to GNews response format
3. **Categories**: Updated to GNews-supported categories
4. **Parameters**: Modified to match GNews API parameters
5. **Error Handling**: Updated for GNews-specific errors

## Best Practices

1. **API Key Security**: Never commit API keys to version control
2. **Rate Limiting**: Implement proper rate limiting
3. **Caching**: Use local caching for better performance
4. **Error Handling**: Handle all possible error scenarios
5. **Testing**: Write comprehensive tests for API integration

## Support

For GNews API support:
- Documentation: https://gnews.io/docs
- Support: https://gnews.io/support
- Upgrade: https://gnews.io/change-plan
