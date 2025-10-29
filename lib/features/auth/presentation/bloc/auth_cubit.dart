import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';

/// Authentication state
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {}

/// Loading state
class AuthLoading extends AuthState {}

/// Authenticated state
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class Unauthenticated extends AuthState {}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Password reset sent state
class PasswordResetSent extends AuthState {}

/// Profile updated state
class ProfileUpdated extends AuthState {
  final User user;

  const ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Account deleted state
class AccountDeleted extends AuthState {}

/// Authentication cubit
class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmailAndPassword _signInWithEmailAndPassword;
  final SignUpWithEmailAndPassword _signUpWithEmailAndPassword;
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final SignOut _signOut;
  final GetCurrentUser getCurrentUser;
  final IsSignedIn isSignedIn;
  final SendPasswordResetEmail _sendPasswordResetEmail;
  final UpdateUserProfile _updateUserProfile;
  final DeleteUserAccount _deleteUserAccount;

  AuthCubit({
    required SignInWithEmailAndPassword signInWithEmailAndPassword,
    required SignUpWithEmailAndPassword signUpWithEmailAndPassword,
    required SignInWithGoogle signInWithGoogle,
    required SignInWithApple signInWithApple,
    required SignOut signOut,
    required this.getCurrentUser,
    required this.isSignedIn,
    required SendPasswordResetEmail sendPasswordResetEmail,
    required UpdateUserProfile updateUserProfile,
    required DeleteUserAccount deleteUserAccount,
  }) : _signInWithEmailAndPassword = signInWithEmailAndPassword,
       _signUpWithEmailAndPassword = signUpWithEmailAndPassword,
       _signInWithGoogle = signInWithGoogle,
       _signInWithApple = signInWithApple,
       _signOut = signOut,
       _sendPasswordResetEmail = sendPasswordResetEmail,
       _updateUserProfile = updateUserProfile,
       _deleteUserAccount = deleteUserAccount,
       super(AuthInitial()) {
    checkAuthStatus();
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await getCurrentUser();

    result.fold((failure) => emit(Unauthenticated()), (User? user) {
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _signInWithEmailAndPassword(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (User user) => emit(Authenticated(user: user)),
    );
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());

    final result = await _signUpWithEmailAndPassword(
      SignUpParams(email: email, password: password, name: name),
    );

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (User user) => emit(Authenticated(user: user)),
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    final result = await _signInWithGoogle();

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (User user) => emit(Authenticated(user: user)),
    );
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    emit(AuthLoading());

    final result = await _signInWithApple();

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (User user) => emit(Authenticated(user: user)),
    );
  }

  /// Sign out
  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await _signOut();

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());

    final result = await _sendPasswordResetEmail(
      SendPasswordResetEmailParams(email: email),
    );

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (_) => emit(PasswordResetSent()),
    );
  }

  /// Update user profile
  Future<void> updateUserProfile(User user) async {
    emit(AuthLoading());

    final result = await _updateUserProfile(
      UpdateUserProfileParams(user: user),
    );

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (User updatedUser) => emit(ProfileUpdated(user: updatedUser)),
    );
  }

  /// Delete user account
  Future<void> deleteUserAccount() async {
    emit(AuthLoading());

    final result = await _deleteUserAccount();

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AccountDeleted()),
    );
  }

  /// Clear error
  void clearError() {
    if (state is AuthError) {
      emit(Unauthenticated());
    }
  }
}
