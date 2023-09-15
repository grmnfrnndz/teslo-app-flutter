import 'package:teslo_shop/features/products/domain/domain.dart';

abstract class ProductsDatasource {

  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductById(String productId);
  Future<List<Product>> searchProductsByTerm(String term);
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);

}