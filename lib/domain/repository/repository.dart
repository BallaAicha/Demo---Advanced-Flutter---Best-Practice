import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';

import 'package:testeur/domain/model/page_response.dart';
import '../model/login_response.dart';
abstract class AuthRepository {
  Future<Either<String, LoginResponse>> login(String email, String password);



}