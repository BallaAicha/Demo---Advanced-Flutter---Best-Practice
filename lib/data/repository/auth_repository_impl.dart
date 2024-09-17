import 'package:dartz/dartz.dart';
import '../../domain/model/login_response.dart';
import '../../domain/repository/repository.dart';
import '../datasource/auth_data_source.dart';
import '../datasource/course_data_source.dart';
import '../request/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<String, LoginResponse>> login(String email, String password) async {
    try {
      final response = await dataSource.login(LoginRequest(email: email, password: password));
      if (response.statusCode == 200) {
        return Right(LoginResponse.fromJson(response.data));
      } else {
        return Left('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }




}