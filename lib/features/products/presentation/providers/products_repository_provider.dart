import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/providers.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';


final productsRepositoryProvider = Provider<ProductsRepository>((ref) {

  final token = ref.watch(authProvider).user?.token ?? '';

  final productsRepository = ProductsRepositoryImpl(
    datasource: ProductsDatasourceImpl(accessToken: token)
    );

  return productsRepository;
});