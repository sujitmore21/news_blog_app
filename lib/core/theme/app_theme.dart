import 'package:flutter/material.dart';

/// Application theme configuration - NewsHub style
class AppTheme {
  // NewsHub-inspired colors
  static const Color primaryColor = Color(0xFFF44336); // Red accent
  static const Color backgroundColor = Color(0xFF1A1A1A); // Dark background
  static const Color cardColor = Color(0xFF2A2A2A); // Dark card
  static const Color textColor = Color(0xFFFFFFFF); // White text
  static const Color textSecondaryColor = Color(0xFFB0B0B0); // Gray text
  static const Color dividerColor = Color(0xFF3A3A3A); // Divider

  static ThemeData get lightTheme {
    return _buildTheme(Brightness.light);
  }

  static ThemeData get darkTheme {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDark
          ? backgroundColor
          : const Color(0xFFF5F5F5),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: primaryColor,
        onSecondary: Colors.white,
        error: const Color(0xFFF44336),
        onError: Colors.white,
        surface: isDark ? cardColor : Colors.white,
        onSurface: isDark ? textColor : Colors.black87,
        surfaceVariant: isDark
            ? const Color(0xFF3A3A3A)
            : const Color(0xFFE0E0E0),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: isDark ? backgroundColor : Colors.white,
        foregroundColor: isDark ? textColor : Colors.black87,
        titleTextStyle: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: isDark ? textColor : Colors.black87),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? cardColor : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.zero,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        displayMedium: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        displaySmall: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          color: isDark ? textSecondaryColor : Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: isDark ? textSecondaryColor : Colors.black54,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: isDark ? textSecondaryColor : Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.15,
        ),
        labelLarge: TextStyle(
          color: isDark ? textColor : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? cardColor : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? dividerColor : Colors.grey.shade300,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerColor: dividerColor,
    );
  }
}
