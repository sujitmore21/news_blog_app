import 'package:dartz/dartz.dart';
import 'package:news_blog_app/core/errors/failures.dart';
import 'package:news_blog_app/core/usecase.dart';
import 'package:news_blog_app/features/auth/domain/entities/user.dart';
import 'package:news_blog_app/features/auth/domain/repositories/auth_repository.dart';

/// Sign in with email and password use case
class SignInWithEmailAndPassword implements UseCase<User, SignInParams> {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

/// Sign up with email and password use case
class SignUpWithEmailAndPassword implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Sign in with Google use case
class SignInWithGoogle implements UseCaseNoParams<User> {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}

/// Sign in with Apple use case
class SignInWithApple implements UseCaseNoParams<User> {
  final AuthRepository repository;

  SignInWithApple(this.repository);

  @override
  Future<Either<Failure, User>> call() async {
    return await repository.signInWithApple();
  }
}

/// Sign out use case
class SignOut implements UseCaseNoParams<void> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}

/// Get current user use case
class GetCurrentUser implements UseCaseNoParams<User?> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}

/// Check if user is signed in use case
class IsSignedIn implements UseCaseNoParams<bool> {
  final AuthRepository repository;

  IsSignedIn(this.repository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.isSignedIn();
  }
}

/// Send password reset email use case
class SendPasswordResetEmail
    implements UseCase<void, SendPasswordResetEmailParams> {
  final AuthRepository repository;

  SendPasswordResetEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(
    SendPasswordResetEmailParams params,
  ) async {
    return await repository.sendPasswordResetEmail(params.email);
  }
}

/// Update user profile use case
class UpdateUserProfile implements UseCase<User, UpdateUserProfileParams> {
  final AuthRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.user);
  }
}

/// Delete user account use case
class DeleteUserAccount implements UseCaseNoParams<void> {
  final AuthRepository repository;

  DeleteUserAccount(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.deleteUserAccount();
  }
}

/// Parameters classes
class SignInParams extends Params {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpParams extends Params {
  final String email;
  final String password;
  final String name;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class SendPasswordResetEmailParams extends Params {
  final String email;

  const SendPasswordResetEmailParams({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateUserProfileParams extends Params {
  final User user;

  const UpdateUserProfileParams({required this.user});

  @override
  List<Object?> get props => [user];
}
