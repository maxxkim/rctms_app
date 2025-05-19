// lib/app/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();
  
  static const String baseUrl = 'http://127.0.0.1:4000'; // For Android emulator pointing to localhost
  static const String graphqlEndpoint = '$baseUrl/api/graphql';
  static const String socketEndpoint = '$baseUrl/socket';
  
  // Remove REST endpoints
  // static const String loginEndpoint = '$baseUrl/api/users/sign_in';
  // static const String registerEndpoint = '$baseUrl/api/users';
  
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}