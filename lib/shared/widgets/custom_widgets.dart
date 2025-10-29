import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Custom loading widget
class CustomLoadingWidget extends StatelessWidget {
  final String? message;

  const CustomLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom error widget
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}

/// Custom empty state widget
class CustomEmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const CustomEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}

/// Custom image widget with error handling
class CustomImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  /// Helper method to safely convert double to int if finite
  int? _getFiniteInt(double? value) {
    if (value == null) return null;
    if (!value.isFinite) return null;
    return value.toInt();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF1E1E1E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'Image unavailable',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty or invalid URLs
    final uri = Uri.tryParse(imageUrl);
    if (imageUrl.isEmpty || uri == null || !uri.hasScheme) {
      return _buildErrorWidget(context);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Referer': 'https://www.google.com/',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
      },
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
      errorWidget: (context, url, error) {
        // Log error for debugging (can be removed in production)
        if (error is Exception) {
          // Handle 403, 404, or any other HTTP errors gracefully
        }
        return errorWidget ?? _buildErrorWidget(context);
      },
      // Retry configuration
      maxHeightDiskCache: 1000,
      maxWidthDiskCache: 1000,
      // Handle memcache errors - only set if values are finite (not infinity or NaN)
      memCacheHeight: _getFiniteInt(height),
      memCacheWidth: _getFiniteInt(width),
    );
  }
}

/// Custom button widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(text),
      ),
    );
  }
}
