// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

// Note: UserModelAdapter is manually created in user_model_adapter.dart
// because Hive generator doesn't properly handle classes that extend
// other classes with super parameters

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  bio: json['bio'] as String?,
  interests: (json['interests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  fcmToken: json['fcmToken'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'profileImageUrl': instance.profileImageUrl,
  'bio': instance.bio,
  'interests': instance.interests,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'isEmailVerified': instance.isEmailVerified,
  'fcmToken': instance.fcmToken,
};
