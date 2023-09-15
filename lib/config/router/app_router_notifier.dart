import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/providers.dart';



final appRouterNotifierProvider = Provider((ref) {

  final authProviderNotifier = ref.read(authProvider.notifier);

  return AppRouterNotifier(authProviderNotifier);
});


class AppRouterNotifier extends ChangeNotifier {

  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  AppRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
