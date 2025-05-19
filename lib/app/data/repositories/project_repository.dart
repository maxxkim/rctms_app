// lib/app/data/repositories/project_repository.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rctms/app/core/errors/exceptions.dart' as app_exceptions;
import 'package:rctms/app/core/network/graphql_client.dart';
import 'package:rctms/app/data/models/project_model.dart';

class ProjectRepository {
  final GraphQLClientProvider graphQLClientProvider;

  ProjectRepository({required this.graphQLClientProvider});

  Future<List<ProjectModel>> getProjects({
    String? searchQuery,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final client = await graphQLClientProvider.getClient();

      const String query = r'''
        query Projects($filter: ProjectFilterInput!) {
          projects_paginated(filter: $filter) {
            entries {
              id
              name
              description
              owner {
                id
                username
                email
              }
              insertedAt
              updatedAt
            }
            pageNumber
            pageSize
            totalEntries
            totalPages
          }
        }
        ''';

      final Map<String, dynamic> variables = {
        'filter': {
          if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
          'page': page,
          'perPage': perPage,
        }
      };

      final QueryOptions options = QueryOptions(
        document: gql(query),
        variables: variables,
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(
              result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException(
              "Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Failed to fetch projects');
      }

      final projectsData = result.data!['projects_paginated']['entries'] as List<dynamic>;
      
      return projectsData
          .map((project) => ProjectModel.fromJson({
                'id': project['id'],
                'name': project['name'],
                'description': project['description'],
                'ownerId': project['owner']['id'],
                'createdAt': project['insertedAt'],
                'updatedAt': project['updatedAt'],
              }))
          .toList();
    } catch (e) {
      if (e is app_exceptions.ServerException ||
          e is app_exceptions.NetworkException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }

  Future<ProjectModel> getProjectById(String id) async {
    try {
      final client = await graphQLClientProvider.getClient();

      const String query = r'''
      query GetProject($id: ID!) {
        project(id: $id) {
          id
          name
          description
          owner {
            id
            username
            email
          }
          insertedAt
          updatedAt
        }
      }
      ''';

      final QueryOptions options = QueryOptions(
        document: gql(query),
        variables: {'id': id},
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(
              result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException(
              "Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Failed to fetch project');
      }

      final projectData = result.data!['project'];
      
      return ProjectModel.fromJson({
        'id': projectData['id'],
        'name': projectData['name'],
        'description': projectData['description'],
        'ownerId': projectData['owner']['id'],
        'createdAt': projectData['insertedAt'],
        'updatedAt': projectData['updatedAt'],
      });
    } catch (e) {
      if (e is app_exceptions.ServerException ||
          e is app_exceptions.NetworkException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }

  Future<ProjectModel> createProject(String name, String? description) async {
    try {
      final client = await graphQLClientProvider.getClient();

      const String mutation = r'''
      mutation CreateProject($input: ProjectInput!) {
        createProject(input: $input) {
          id
          name
          description
          owner {
            id
            username
            email
          }
          insertedAt
          updatedAt
        }
      }
      ''';

      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {
          'input': {
            'name': name,
            'description': description,
          }
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(
              result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException(
              "Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Failed to create project');
      }

      final projectData = result.data!['createProject'];
      
      return ProjectModel.fromJson({
        'id': projectData['id'],
        'name': projectData['name'],
        'description': projectData['description'],
        'ownerId': projectData['owner']['id'],
        'createdAt': projectData['insertedAt'],
        'updatedAt': projectData['updatedAt'],
      });
    } catch (e) {
      if (e is app_exceptions.ServerException ||
          e is app_exceptions.NetworkException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }

  Future<ProjectModel> updateProject(String id, String name, String? description) async {
    try {
      final client = await graphQLClientProvider.getClient();

      const String mutation = r'''
      mutation UpdateProject($id: ID!, $input: ProjectInput!) {
        updateProject(id: $id, input: $input) {
          id
          name
          description
          owner {
            id
            username
            email
          }
          insertedAt
          updatedAt
        }
      }
      ''';

      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          'input': {
            'name': name,
            'description': description,
          }
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(
              result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException(
              "Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Failed to update project');
      }

      final projectData = result.data!['updateProject'];
      
      return ProjectModel.fromJson({
        'id': projectData['id'],
        'name': projectData['name'],
        'description': projectData['description'],
        'ownerId': projectData['owner']['id'],
        'createdAt': projectData['insertedAt'],
        'updatedAt': projectData['updatedAt'],
      });
    } catch (e) {
      if (e is app_exceptions.ServerException ||
          e is app_exceptions.NetworkException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      final client = await graphQLClientProvider.getClient();

      const String mutation = r'''
      mutation DeleteProject($id: ID!) {
        deleteProject(id: $id) {
          id
        }
      }
      ''';

      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {'id': id},
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(
              result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException(
              "Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Failed to delete project');
      }

      return true;
    } catch (e) {
      if (e is app_exceptions.ServerException ||
          e is app_exceptions.NetworkException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }
}