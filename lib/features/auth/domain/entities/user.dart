import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String? bio;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final String? fcmToken;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.bio,
    required this.interests,
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    profileImageUrl,
    bio,
    interests,
    createdAt,
    lastLoginAt,
    isEmailVerified,
    fcmToken,
  ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? bio,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    String? fcmToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
