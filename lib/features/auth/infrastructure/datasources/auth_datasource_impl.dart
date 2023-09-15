import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrasctructure.dart';


class AuthDatasourceImpl implements AuthDatasource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );  


  @override
  Future<User> checkAuthStatus(String token) async {

    try {

      final response = await dio.get('/auth/check-status', 
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ));

      final user = UserMapper.userJsonToEntity(response.data);

      return user;

     } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(messaage: 'Token invalid');
      }

      throw Exception('Something wrong happend');
    } catch (e) {
      throw Exception('Something wrong happend');
    }

  }

  @override
  Future<User> login(String email, String password) async {
    
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.response?.statusCode == 401) {
        throw CustomError(messaage: e.response?.data['message'] ?? 'Something wrong happend');
      }
      if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeOut();

      throw CustomError(messaage: 'Something wrong happend');
    } catch (e) {
      throw CustomError(messaage: 'Something wrong happend');
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}