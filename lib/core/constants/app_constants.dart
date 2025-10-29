import '../config/app_config.dart';

/// Application constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://gnews.io/api/v4';
  static const String apiKey = AppConfig.gnewsApiKey;

  // Cache Configuration
  static const String cacheBoxName = 'news_cache';
  static const int cacheExpirationMinutes = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image Configuration
  static const String defaultImageUrl = 'https://via.placeholder.com/300x200';
  static const Duration imageCacheDuration = Duration(days: 7);

  // Network Configuration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Error Messages
  static const String networkErrorMessage = 'No internet connection';
  static const String serverErrorMessage = 'Server error occurred';
  static const String unknownErrorMessage = 'An unknown error occurred';
  static const String cacheErrorMessage = 'Cache error occurred';
}
