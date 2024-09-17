import 'package:dio/dio.dart';
import '../../app/manager/token_manager.dart';
class DioFactory {
  final TokenManager tokenManager;
  DioFactory(this.tokenManager);
  Future<Dio> createDio() async {
    final dio = Dio();
    final accessToken = await tokenManager.getAccessToken();
    if (accessToken != null) {
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return dio;
  }
}