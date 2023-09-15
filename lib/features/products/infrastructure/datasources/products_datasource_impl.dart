import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';


class ProductsDatasourceImpl implements ProductsDatasource {

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken
    }): dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,
        headers: {
          'Authorization': 'Bearer $accessToken'
        }
      )
    );


  Future<String> _uploadPhoto(String imagePath) async {

    try {
      final fileName = imagePath.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(imagePath, filename: fileName)
      });

      final response = await dio.post('/files/product', data: data);

      return response.data['image'];

    } catch (e) {
      throw Exception();
    }

  }


  Future<List<String>> _uploadPhotos(List<String> images) async {

    final photosToUpload = images.where((element) => element.contains('/')).toList();
    final photosIgnore = images.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadJobs = photosToUpload.map(_uploadPhoto).toList();
    final newImages = await Future.wait(uploadJobs);


    return [...newImages, ...photosIgnore];
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {

    try {
      final String? productId = productLike['id'];
      final String method = productId == null ? 'POST' : 'PATCH';
      final String url = productId == null ? '/products' : '/products/$productId';
      productLike.remove('id');
      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request(
        url, 
        data: productLike,
        options: Options(
          method: method
        )
        );

      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } catch (e) {
      print('ERROR -> ERROR');
      print(e);
      throw Exception();
    }

  }

  @override
  Future<Product> getProductById(String productId) async {

    try {
      final response = await dio.get('/products/$productId');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    }
    catch (e) {
      throw Exception();
    }

  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0})  async {
    final response  = await dio.get<List>('/products', queryParameters: {
      'limit': limit,
      'offset': offset
    });

    List<Product> products = [];

    for (final productJson in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(productJson));
    }

    // final products = response.data == null ? []: response.data!.map((e) => ProductMapper.jsonToEntity(e)).toList();

    return products;
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }

}
