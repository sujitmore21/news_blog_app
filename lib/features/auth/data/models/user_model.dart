import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User data model
@HiveType(typeId: 0)
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    @HiveField(0) required super.id,
    @HiveField(1) required super.email,
    @HiveField(2) required super.name,
    @HiveField(3) super.profileImageUrl,
    @HiveField(4) super.bio,
    @HiveField(5) required super.interests,
    @HiveField(6) required super.createdAt,
    @HiveField(7) super.lastLoginAt,
    @HiveField(8) super.isEmailVerified = false,
    @HiveField(9) super.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImageUrl: user.profileImageUrl,
      bio: user.bio,
      interests: user.interests,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      isEmailVerified: user.isEmailVerified,
      fcmToken: user.fcmToken,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      profileImageUrl: profileImageUrl,
      bio: bio,
      interests: interests,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      isEmailVerified: isEmailVerified,
      fcmToken: fcmToken,
    );
  }
}
