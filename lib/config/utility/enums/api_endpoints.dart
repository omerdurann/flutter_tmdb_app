import '../../../core/constants/api_constants.dart';

enum ApiEndPoints {
  //? login
  login("auth/login"),
  ;

  const ApiEndPoints(this.endPoint);
  String get getEndpoint => ApiConstants.baseUrl + endPoint;

  final String endPoint;
}
