import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import '../entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, User>> signInWithApple();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is signed in
  Future<Either<Failure, bool>> isSignedIn();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<Either<Failure, User>> updateUserProfile(User user);

  /// Delete user account
  Future<Either<Failure, void>> deleteUserAccount();

  /// Refresh user token
  Future<Either<Failure, String>> refreshToken();

  /// Save user data locally
  Future<Either<Failure, void>> saveUserData(User user);

  /// Get cached user data
  Future<Either<Failure, User?>> getCachedUserData();
}
