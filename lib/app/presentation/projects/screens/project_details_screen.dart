// lib/app/presentation/projects/screens/project_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rctms/app/presentation/projects/screens/edit_project_screen.dart';
import 'package:rctms/app/providers/project_providers.dart';

class ProjectDetailsScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  ProjectDetailsScreenState createState() => ProjectDetailsScreenState();
}

class ProjectDetailsScreenState extends ConsumerState<ProjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем детали проекта при первой загрузке экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectProvider.notifier).getProject(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectState.project.value?.name ?? 'Project Details',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: projectState.project.value == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditProjectScreen(
                          project: projectState.project.value!,
                        ),
                      ),
                    ).then((_) {
                      // Обновляем детали проекта после редактирования
                      ref
                          .read(projectProvider.notifier)
                          .getProject(widget.projectId);
                    });
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: projectState.project.value == null
                ? null
                : () {
                    _showDeleteConfirmationDialog(context);
                  },
          ),
        ],
      ),
      body: projectState.project.when(
        data: (project) {
          if (project == null) {
            return const Center(
              child: Text('Project not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Project Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description ?? 'No description provided',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Created: ${_formatDate(project.createdAt)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last Updated: ${_formatDate(project.updatedAt)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'No tasks yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Реализовать создание задач
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task creation will be implemented soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading project: ${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(projectProvider.notifier).getProject(widget.projectId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text(
          'Are you sure you want to delete this project? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _deleteProject();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProject() async {
  // Сохраняем необходимые объекты до асинхронной операции
  final navigator = Navigator.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  
  // Показываем индикатор загрузки
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    final success = await ref
        .read(projectProvider.notifier)
        .deleteProject(widget.projectId);

    // Проверяем, смонтирован ли еще виджет
    if (!mounted) return;
    
    // Закрываем диалог загрузки
    navigator.pop();

    if (success) {
      navigator.pop(); // Возвращаемся на предыдущий экран
      
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Project deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to delete project'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Проверяем, смонтирован ли еще виджет
    if (!mounted) return;
    
    // Закрываем диалог загрузки
    navigator.pop();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}