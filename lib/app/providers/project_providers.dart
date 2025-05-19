// lib/app/providers/project_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rctms/app/data/models/project_model.dart';
import 'package:rctms/app/data/repositories/project_repository.dart';
import 'package:rctms/app/providers.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final graphQLClient = ref.watch(graphQLClientProvider);
  return ProjectRepository(graphQLClientProvider: graphQLClient);
});

// Состояние для списка проектов
class ProjectsState {
  final AsyncValue<List<ProjectModel>> projects;
  final String? searchQuery;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  ProjectsState({
    this.projects = const AsyncValue.loading(),
    this.searchQuery,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  ProjectsState copyWith({
    AsyncValue<List<ProjectModel>>? projects,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  final ProjectRepository _projectRepository;

  ProjectsNotifier({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(ProjectsState());

  Future<void> getProjects({String? searchQuery, bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        projects: const AsyncValue.loading(),
        currentPage: 1,
        searchQuery: searchQuery,
      );
    } else if (searchQuery != state.searchQuery) {
      state = state.copyWith(
        searchQuery: searchQuery,
        currentPage: 1,
      );
    }

    try {
      final projects = await _projectRepository.getProjects(
        searchQuery: state.searchQuery,
        page: state.currentPage,
        perPage: 10,
      );

      // Обновляем состояние с новыми проектами
      state = state.copyWith(
        projects: AsyncValue.data(projects),
        hasMore: projects.length >= 10, // Предполагаем, что есть еще, если получили полную страницу
        totalPages: (projects.length / 10).ceil(), // Предполагаемое количество страниц
      );
    } catch (e) {
      state = state.copyWith(
        projects: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> loadMoreProjects() async {
    if (!state.hasMore || state.projects is AsyncLoading) {
      return;
    }

    // Получаем текущие проекты
    final currentProjects = state.projects.value ?? [];

    try {
      // Увеличиваем номер страницы
      state = state.copyWith(
        currentPage: state.currentPage + 1,
      );

      // Получаем следующую страницу проектов
      final newProjects = await _projectRepository.getProjects(
        searchQuery: state.searchQuery,
        page: state.currentPage,
        perPage: 10,
      );

      // Добавляем новые проекты к существующим
      state = state.copyWith(
        projects: AsyncValue.data([...currentProjects, ...newProjects]),
        hasMore: newProjects.length >= 10, // Есть ли еще проекты для загрузки
      );
    } catch (e) {
      // В случае ошибки сохраняем текущие проекты, но сообщаем об ошибке
      state = state.copyWith(
        currentPage: state.currentPage - 1, // Возвращаем предыдущую страницу
        projects: AsyncValue.data(currentProjects),
      );

      // Показываем ошибку (можно добавить обработку в UI)
      //print("Error loading more projects: $e");
    }
  }

  Future<void> searchProjects(String query) async {
    state = state.copyWith(
      searchQuery: query,
      currentPage: 1,
      projects: const AsyncValue.loading(),
    );

    try {
      final projects = await _projectRepository.getProjects(
        searchQuery: query,
        page: 1,
        perPage: 10,
      );

      state = state.copyWith(
        projects: AsyncValue.data(projects),
        hasMore: projects.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        projects: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> refreshProjects() async {
    await getProjects(searchQuery: state.searchQuery, refresh: true);
  }
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  final projectRepository = ref.watch(projectRepositoryProvider);
  return ProjectsNotifier(projectRepository: projectRepository);
});

// Состояние для отдельного проекта
class ProjectState {
  final AsyncValue<ProjectModel?> project;

  ProjectState({
    this.project = const AsyncValue.loading(),
  });

  ProjectState copyWith({
    AsyncValue<ProjectModel?>? project,
  }) {
    return ProjectState(
      project: project ?? this.project,
    );
  }
}

class ProjectNotifier extends StateNotifier<ProjectState> {
  final ProjectRepository _projectRepository;

  ProjectNotifier({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(ProjectState());

  Future<void> getProject(String id) async {
    state = ProjectState(project: const AsyncValue.loading());

    try {
      final project = await _projectRepository.getProjectById(id);
      state = state.copyWith(project: AsyncValue.data(project));
    } catch (e) {
      state = state.copyWith(
        project: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> createProject(String name, String? description) async {
    state = ProjectState(project: const AsyncValue.loading());

    try {
      final createdProject = await _projectRepository.createProject(name, description);
      state = state.copyWith(project: AsyncValue.data(createdProject));
    } catch (e) {
      state = state.copyWith(
        project: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> updateProject(String id, String name, String? description) async {
    state = ProjectState(project: const AsyncValue.loading());

    try {
      final updatedProject = await _projectRepository.updateProject(id, name, description);
      state = state.copyWith(project: AsyncValue.data(updatedProject));
    } catch (e) {
      state = state.copyWith(
        project: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      final result = await _projectRepository.deleteProject(id);
      if (result) {
        state = state.copyWith(project: const AsyncValue.data(null));
      }
      return result;
    } catch (e) {
      return false;
    }
  }
}

final projectProvider = StateNotifierProvider.autoDispose<ProjectNotifier, ProjectState>((ref) {
  final projectRepository = ref.watch(projectRepositoryProvider);
  return ProjectNotifier(projectRepository: projectRepository);
});