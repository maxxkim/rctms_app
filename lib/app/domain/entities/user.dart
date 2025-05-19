// lib/domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String username;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  User({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
  });
}