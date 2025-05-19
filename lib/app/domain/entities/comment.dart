// lib/domain/entities/comment.dart
class Comment {
  final String id;
  final String content;
  final String taskId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Comment({
    required this.id,
    required this.content,
    required this.taskId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
}