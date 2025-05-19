import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rctms/app/core/errors/exceptions.dart'as app_exceptions; 
import 'package:rctms/app/core/network/graphql_client.dart';
import 'package:rctms/app/data/models/user_model.dart';

class AuthRepository {
  final GraphQLClientProvider graphQLClientProvider;
  
  AuthRepository({required this.graphQLClientProvider});
  
  Future<Map<String, dynamic>> register(String email, String username, String password) async {
    try {
      final client = await graphQLClientProvider.getClient();
      
      const String mutation = r'''
      mutation Register($input: UserRegistrationInput!) {
        register(input: $input) {
          token
          user {
            id
            email
            username
            insertedAt
            updatedAt
          }
        }
      }
      ''';
      
      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {
          'input': {
            'email': email,
            'username': username,
            'password': password
          }
        },
      );
      
      final QueryResult result = await client.mutate(options);
      
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException("Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Registration failed');
      }
      
      final registerData = result.data!['register'];
      final userData = UserModel.fromJson({
        'id': registerData['user']['id'],
        'email': registerData['user']['email'],
        'username': registerData['user']['username'],
        'createdAt': registerData['user']['insertedAt'],
        'updatedAt': registerData['user']['updatedAt'],
      });
      
      return {
        'user': userData,
        'token': registerData['token'],
      };
    } catch (e) {
      if (e is app_exceptions.ServerException || 
          e is app_exceptions.NetworkException ||
          e is app_exceptions.AuthenticationException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final client = await graphQLClientProvider.getClient();
      
      const String mutation = r'''
      mutation Login($input: UserLoginInput!) {
        login(input: $input) {
          token
          user {
            id
            email
            username
            insertedAt
            updatedAt
          }
        }
      }
      ''';
      
      final MutationOptions options = MutationOptions(
        document: gql(mutation),
        variables: {
          'input': {
            'email': email,
            'password': password
          }
        },
      );
      
      final QueryResult result = await client.mutate(options);
      
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty) {
          final errorMessage = result.exception!.graphqlErrors.first.message;
          if (errorMessage.contains('Invalid email or password')) {
            throw app_exceptions.AuthenticationException('Invalid email or password');
          }
          throw app_exceptions.ServerException(errorMessage);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException("Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Login failed');
      }
      
      final loginData = result.data!['login'];
      final userData = UserModel.fromJson({
        'id': loginData['user']['id'],
        'email': loginData['user']['email'],
        'username': loginData['user']['username'],
        'createdAt': loginData['user']['insertedAt'],
        'updatedAt': loginData['user']['updatedAt'],
      });
      
      return {
        'user': userData,
        'token': loginData['token'],
      };
    } catch (e) {
      if (e is app_exceptions.ServerException || 
          e is app_exceptions.NetworkException ||
          e is app_exceptions.AuthenticationException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }
  
  Future<UserModel?> getCurrentUser() async {
    try {
      final client = await graphQLClientProvider.getClient();
      
      const String query = r'''
      query Me {
        me {
          id
          email
          username
          insertedAt
          updatedAt
        }
      }
      ''';
      
      final QueryOptions options = QueryOptions(
        document: gql(query),
      );
      
      final QueryResult result = await client.query(options);
      
      if (result.hasException) {
        if (result.exception!.graphqlErrors.any((error) => 
          error.message.contains('not authenticated') || 
          error.message.contains('not found'))) {
          return null;
        }
        if (result.exception!.graphqlErrors.isNotEmpty) {
          throw app_exceptions.ServerException(result.exception!.graphqlErrors.first.message);
        }
        if (result.exception!.linkException != null) {
          throw app_exceptions.NetworkException("Connection error: Unable to connect to server");
        }
        throw app_exceptions.ServerException('Failed to fetch user data');
      }
      
      if (result.data == null || result.data!['me'] == null) {
        return null;
      }
      
      final userData = result.data!['me'];
      return UserModel.fromJson({
        'id': userData['id'],
        'email': userData['email'],
        'username': userData['username'],
        'createdAt': userData['insertedAt'],
        'updatedAt': userData['updatedAt'],
      });
    } catch (e) {
      if (e is app_exceptions.ServerException || 
          e is app_exceptions.NetworkException) {
        rethrow;
      }
      throw app_exceptions.NetworkException('Connection error: ${e.toString()}');
    }
  }
}