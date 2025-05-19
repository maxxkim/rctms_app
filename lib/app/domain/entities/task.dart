// lib/domain/entities/task.dart
enum TaskStatus { pending, inProgress, completed }

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String projectId;
  final String? assigneeId;
  final String creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.projectId,
    this.assigneeId,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
  });
}