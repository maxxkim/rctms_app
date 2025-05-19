// lib/core/network/graphql_client.dart
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rctms/app/core/constants/api_constants.dart';
import 'package:rctms/app/core/storage/secure_storage.dart';

class GraphQLClientProvider {
  final SecureStorage secureStorage;
  
  GraphQLClientProvider(this.secureStorage);
  
  Future<GraphQLClient> getClient() async {
    final token = await secureStorage.getAuthToken();
    
    final httpLink = HttpLink(ApiConstants.graphqlEndpoint);
    
    final authLink = AuthLink(
      getToken: () => token != null ? 'Bearer $token' : null,
    );
    
    final Link link = authLink.concat(httpLink);
    
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
  
  // For WebSocket connections (subscriptions)
  Future<GraphQLClient> getWebSocketClient() async {
    final token = await secureStorage.getAuthToken();
    
    final httpLink = HttpLink(ApiConstants.graphqlEndpoint);
    
    // WebSocket link for subscriptions
    final wsLink = WebSocketLink(
      ApiConstants.socketEndpoint,
      config: SocketClientConfig(
        initialPayload: token != null 
            ? {'token': token} 
            : null,
        autoReconnect: true,
      ),
    );
    
    // Use WebSocket for subscriptions, HTTP for queries and mutations
    final link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      httpLink,
    );
    
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}