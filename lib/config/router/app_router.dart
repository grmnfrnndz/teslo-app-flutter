import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

import '../../features/auth/providers/providers.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {

  final appRouterNotifier = ref.read(appRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: appRouterNotifier,
    routes: [
      /// * First route
      
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),


      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),

      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.params['id'] ?? 'no-id';

        return ProductScreen(productId: productId);
        },
      ),

    ],
    
    redirect: (context, state) {
      
      final isGoinTo = state.subloc;
      final authStatus = appRouterNotifier.authStatus;

      // print('$isGoinTo $authStatus');

      if (isGoinTo == '/splash' && authStatus == AuthStatus.checking) return null;
      
      if (authStatus == AuthStatus.notAuthenticated) {
        if(isGoinTo == '/login' || isGoinTo == '/register') return null;
        
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if(isGoinTo == '/login' || isGoinTo == '/register' || isGoinTo == '/splash') return '/';
      }

      return null;
    },
  );

});
