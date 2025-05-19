// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;
  
  SecureStorage(this._storage);
  
  // Token storage keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  
  // Store auth token
  Future<void> storeAuthToken(String token) async {
    await _storage.write(key: authTokenKey, value: token);
  }
  
  // Get auth token
  Future<String?> getAuthToken() async {
    return await _storage.read(key: authTokenKey);
  }
  
  // Remove auth token
  Future<void> removeAuthToken() async {
    await _storage.delete(key: authTokenKey);
  }
  
  // Store user ID
  Future<void> storeUserId(String userId) async {
    await _storage.write(key: userIdKey, value: userId);
  }
  
  // Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: userIdKey);
  }
  
  // Clear all stored data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}