import 'package:dartz/dartz.dart';
import '../model/login_response.dart';
import '../repository/repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<String, LoginResponse>> execute(String email, String password) {
    return repository.login(email, password);
  }
}