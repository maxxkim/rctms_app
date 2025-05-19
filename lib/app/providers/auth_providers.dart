// lib/app/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rctms/app/core/storage/secure_storage.dart';
import 'package:rctms/app/data/models/user_model.dart';
import 'package:rctms/app/data/repositories/auth_repository.dart';
import 'package:rctms/app/providers.dart' as app_providers;
import 'package:rctms/app/providers.dart';


// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final graphQLClient = ref.watch(app_providers.graphQLClientProvider);
  return AuthRepository(graphQLClientProvider: graphQLClient);
});

// Auth state class
class AuthState {
  final UserModel? user;
  final AsyncValue<void> authStatus;
  final bool isAuthenticated;
  
  AuthState({
    this.user,
    this.authStatus = const AsyncValue.data(null),
    this.isAuthenticated = false,
  });
  
  AuthState copyWith({
    UserModel? user,
    AsyncValue<void>? authStatus,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorage _secureStorage;
  
  AuthNotifier({
    required AuthRepository authRepository,
    required SecureStorage secureStorage,
  }) : _authRepository = authRepository,
      _secureStorage = secureStorage,
      super(AuthState());
  
  Future<void> register(String email, String username, String password) async {
    state = state.copyWith(authStatus: const AsyncValue.loading());
    
    try {
      final result = await _authRepository.register(email, username, password);
      final user = result['user'] as UserModel;
      final token = result['token'] as String;
      
      await _secureStorage.storeAuthToken(token);
      await _secureStorage.storeUserId(user.id);
      
      state = state.copyWith(
        user: user,
        authStatus: const AsyncValue.data(null),
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        authStatus: AsyncValue.error(e, StackTrace.current),
        isAuthenticated: false,
      );
    }
  }
  
  Future<void> login(String email, String password) async {
    state = state.copyWith(authStatus: const AsyncValue.loading());
    
    try {
      final result = await _authRepository.login(email, password);
      final user = result['user'] as UserModel;
      final token = result['token'] as String;
      
      await _secureStorage.storeAuthToken(token);
      await _secureStorage.storeUserId(user.id);
      
      state = state.copyWith(
        user: user,
        authStatus: const AsyncValue.data(null),
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        authStatus: AsyncValue.error(e, StackTrace.current),
        isAuthenticated: false,
      );
    }
  }
  
  Future<void> checkAuthStatus() async {
    state = state.copyWith(authStatus: const AsyncValue.loading());
    
    try {
      final token = await _secureStorage.getAuthToken();
      
      if (token == null) {
        state = state.copyWith(
          authStatus: const AsyncValue.data(null),
          isAuthenticated: false,
        );
        return;
      }
      
      final user = await _authRepository.getCurrentUser();
      
      if (user != null) {
        state = state.copyWith(
          user: user,
          authStatus: const AsyncValue.data(null),
          isAuthenticated: true,
        );
      } else {
        await _secureStorage.clearAll();
        state = state.copyWith(
          authStatus: const AsyncValue.data(null),
          isAuthenticated: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        authStatus: AsyncValue.error(e, StackTrace.current),
        isAuthenticated: false,
      );
    }
  }
  
  Future<void> logout() async {
    await _secureStorage.clearAll();
    state = AuthState();
  }
}

// The provider that will be consumed in the UI
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  
  return AuthNotifier(
    authRepository: authRepository,
    secureStorage: secureStorage,
  );
});