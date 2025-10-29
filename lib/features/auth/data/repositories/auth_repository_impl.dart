import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data locally
      await localDataSource.saveUserData(user);

      return Right(user.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      // Save user data locally
      await localDataSource.saveUserData(user);

      return Right(user.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();

      // Save user data locally
      await localDataSource.saveUserData(user);

      return Right(user.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    try {
      final user = await remoteDataSource.signInWithApple();

      // Save user data locally
      await localDataSource.saveUserData(user);

      return Right(user.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user != null) {
        // Update local data
        await localDataSource.saveUserData(user);
        return Right(user.toEntity());
      } else {
        // Try to get cached user data
        final cachedUser = await localDataSource.getCachedUserData();
        return Right(cachedUser?.toEntity());
      }
    } catch (e) {
      // Try to get cached user data if network fails
      try {
        final cachedUser = await localDataSource.getCachedUserData();
        return Right(cachedUser?.toEntity());
      } catch (cacheError) {
        return Left(AuthFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      return Right(await localDataSource.isSignedIn());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final updatedUser = await remoteDataSource.updateUserProfile(userModel);

      // Update local data
      await localDataSource.saveUserData(updatedUser);

      return Right(updatedUser.toEntity());
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount() async {
    try {
      await remoteDataSource.deleteUserAccount();
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final token = await remoteDataSource.refreshToken();
      return Right(token);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserData(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await localDataSource.saveUserData(userModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCachedUserData() async {
    try {
      final user = await localDataSource.getCachedUserData();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
