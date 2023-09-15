import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/config.dart';

void main() async {
  // variable environment
  // down and up app
  await Environment.initEnvironment();

  // wrap scope provider
  runApp(
    const ProviderScope(child: MainApp())
    );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appRouterProvider = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouterProvider,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
