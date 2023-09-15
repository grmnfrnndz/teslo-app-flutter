import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';

import 'package:teslo_shop/features/auth/infrastructure/infrasctructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';




final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl(); 
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(authRepository: authRepository, keyValueStorageService: keyValueStorageService);
});




class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.keyValueStorageService, 
    required this.authRepository}
    ): super(AuthState()) {
      // when create provider
      checkAuthStatus();
    }

  Future<void> loginUser(String email, String password) async {

      await  Future.delayed(const Duration(milliseconds: 5));

      try {
        final user = await authRepository.login(email, password);
        _setLoggedUser(user);
      } on WrongCredentials catch (_) {
        logout('Credenciales no son correctas');

      } on ConnectionTimeOut catch (_) {
        logout('Timeout');
      } 
      on CustomError catch (error) {
        logout(error.messaage);
      } 
      catch (_) {
        logout('Fatal Error');
      }

      // final user = await authRepository.login(email, password);
      // state = state.copyWith(user: user, authStatus: AuthStatus.authenticated);

  }
  
  registerUser(String email, String password) async {
    
  }

  checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    print(token);
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
        logout();
    }
    
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user, 
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
      );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}


enum AuthStatus {checking, authenticated, notAuthenticated}

class AuthState {
  
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
    });

  
  AuthState copyWith(
    {AuthStatus? authStatus,
    User? user,
    String? errorMessage,}
  ) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}