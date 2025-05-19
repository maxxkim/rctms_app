// lib/app/providers.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rctms/app/core/network/graphql_client.dart';
import 'package:rctms/app/core/network/network_info.dart';
import 'package:rctms/app/core/storage/secure_storage.dart';

// Core providers
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(const FlutterSecureStorage());
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final graphQLClientProvider = Provider<GraphQLClientProvider>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return GraphQLClientProvider(secureStorage);
});

// Additional providers will be added as we implement features