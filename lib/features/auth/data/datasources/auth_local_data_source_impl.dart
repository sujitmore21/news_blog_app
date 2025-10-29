import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Authentication local data source implementation
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _userDataKey = 'user_data';
  static const String _authTokenKey = 'auth_token';
  static const String _isSignedInKey = 'is_signed_in';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      final box = await Hive.openBox<UserModel>('user_data');
      await box.put('current_user', user);
      await sharedPreferences.setBool(_isSignedInKey, true);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUserData() async {
    try {
      final box = await Hive.openBox<UserModel>('user_data');
      return box.get('current_user');
    } catch (e) {
      throw Exception('Failed to get cached user data: $e');
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await sharedPreferences.setString(_authTokenKey, token);
    } catch (e) {
      throw Exception('Failed to save auth token: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return sharedPreferences.getString(_authTokenKey);
    } catch (e) {
      throw Exception('Failed to get auth token: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      final box = await Hive.openBox<UserModel>('user_data');
      await box.clear();
      await sharedPreferences.remove(_authTokenKey);
      await sharedPreferences.setBool(_isSignedInKey, false);
    } catch (e) {
      throw Exception('Failed to clear auth data: $e');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      return sharedPreferences.getBool(_isSignedInKey) ?? false;
    } catch (e) {
      throw Exception('Failed to check sign in status: $e');
    }
  }
}
