import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign in with Apple
  Future<UserModel> signInWithApple();

  /// Sign out
  Future<void> signOut();

  /// Get current user
  Future<UserModel?> getCurrentUser();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<UserModel> updateUserProfile(UserModel user);

  /// Delete user account
  Future<void> deleteUserAccount();

  /// Refresh user token
  Future<String> refreshToken();
}

/// Local data source for authentication
abstract class AuthLocalDataSource {
  /// Save user data locally
  Future<void> saveUserData(UserModel user);

  /// Get cached user data
  Future<UserModel?> getCachedUserData();

  /// Save auth token
  Future<void> saveAuthToken(String token);

  /// Get auth token
  Future<String?> getAuthToken();

  /// Clear all auth data
  Future<void> clearAuthData();

  /// Check if user is signed in
  Future<bool> isSignedIn();
}
