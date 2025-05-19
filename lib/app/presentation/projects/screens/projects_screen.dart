// lib/app/presentation/projects/screens/projects_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rctms/app/presentation/projects/screens/create_project_screen.dart';
import 'package:rctms/app/presentation/projects/screens/project_details_screen.dart';
import 'package:rctms/app/presentation/projects/widgets/project_list_item.dart';
import 'package:rctms/app/providers/project_providers.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  ProjectsScreenState createState() => ProjectsScreenState();
}

class ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Загружаем проекты при первой загрузке экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectsProvider.notifier).getProjects();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Загружаем больше проектов, когда пользователь докрутил до конца
      ref.read(projectsProvider.notifier).loadMoreProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(projectsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreateProjectScreen(),
                ),
              ).then((_) {
                // Обновляем список проектов после создания нового
                ref.read(projectsProvider.notifier).refreshProjects();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(projectsProvider.notifier).searchProjects('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Используем debounce для поиска (можно реализовать отдельно)
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    ref.read(projectsProvider.notifier).searchProjects(value);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(projectsProvider.notifier).refreshProjects();
              },
              child: projectsState.projects.when(
                data: (projects) {
                  if (projects.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_open,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            projectsState.searchQuery != null && 
                            projectsState.searchQuery!.isNotEmpty
                                ? 'No projects found for "${projectsState.searchQuery}"'
                                : 'No projects yet',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CreateProjectScreen(),
                                ),
                              ).then((_) {
                                ref.read(projectsProvider.notifier).refreshProjects();
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create New Project'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: projects.length + (projectsState.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == projects.length) {
                        // Показываем индикатор загрузки в конце списка
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      final project = projects[index];
                      return ProjectListItem(
                        project: project,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailsScreen(
                                projectId: project.id,
                              ),
                            ),
                          ).then((_) {
                            // Обновляем список проектов после возможного обновления или удаления
                            ref.read(projectsProvider.notifier).refreshProjects();
                          });
                        },
                      );
                    },
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
                        'Error loading projects: ${error.toString()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(projectsProvider.notifier).refreshProjects();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}