class WrongCredentials implements Exception {}
class InvalidToken implements Exception {}
class ConnectionTimeOut implements Exception {}
class CustomError implements Exception {
  final String messaage;
  final bool logged;
  // final int errorCode;
  CustomError(
     {
    required this.messaage, 
    // required this.errorCode
    this.logged = false
    }
    );
}