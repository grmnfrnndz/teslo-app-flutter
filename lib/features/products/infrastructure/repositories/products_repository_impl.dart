


import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl implements ProductsRepository {

  final ProductsDatasource datasource;

  // TODO: access token ?

  ProductsRepositoryImpl({required this.datasource});

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return datasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String productId) {
    return datasource.getProductById(productId);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return datasource.searchProductsByTerm(term);
  }
}