import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testeur/app/constant.dart';
import 'package:testeur/data/datasource/student_data_source.dart';
import 'package:testeur/data/request/login_request.dart';

import 'package:testeur/domain/model/login_response.dart';
import 'package:testeur/presentation/instructor/viewmodel/instructor_viewmodel.dart';
import 'package:testeur/presentation/main/main.dart';
import 'package:testeur/presentation/ressources/routes_manager.dart';
import 'package:testeur/presentation/student/viewmodel/student-viewmodel.dart';
import '../../app/manager/token_manager.dart';
import '../../domain/model/logged_user.dart';
import '../../domain/usecases/instructor_usecase.dart';
import '../../domain/usecases/student_usecase.dart';
import '../../presentation/course/courseview.dart';
import '../../presentation/instructor/bloc/instructor_bloc.dart';
import '../../presentation/instructor/bloc/instructor_state.dart';
import '../../presentation/student/bloc/student_bloc.dart';
import '../../presentation/student/bloc/student_state.dart';
import '../repository/instructor_repository_impl.dart';
import '../repository/student_repository.dart';
import 'instructor_data_source.dart';

class AuthDataSource {
  final Dio dio;
  final TokenManager tokenManager;
  final GlobalKey<NavigatorState> navigatorKey;

  AuthDataSource(this.dio, this.tokenManager, this.navigatorKey) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<Response> login(LoginRequest request) async {
    final formData = FormData.fromMap({
      'email': request.email,
      'password': request.password,
    });

    final response = await dio.post(
      '${Constant.baseUrl}/login',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(response.data);
      await tokenManager.saveTokens(loginResponse);

      // Decode the access token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(loginResponse.accessToken);
      LoggedUser loggedUser = LoggedUser(
        decodedToken['sub'],
        List<String>.from(decodedToken['roles']),
        loginResponse.accessToken,
        DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000, isUtc: true),
      );

      // Save the logged user to local storage
      await tokenManager.saveLoggedUser(loggedUser);
      int expirationTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000, isUtc: true).millisecondsSinceEpoch;
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int timeUntilExpiration = expirationTime - currentTime;
      Future.delayed(Duration(milliseconds: timeUntilExpiration), () {
        // Perform auto logout
        tokenManager.clearTokens();
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Routes.loginRoute,
              (route) => false,
        );
      });

      if (decodedToken['roles'].contains('INSTRUCTOR') ) {
        final instructorDataSource = InstructorDataSource(dio, tokenManager);
        final instructorRepository = InstructorRepositoryImpl(instructorDataSource);
        final instructorUseCases = InstructorUseCases(instructorRepository);
        final instructorViewModel = InstructorViewmodel(InstructorBloc(instructorUseCases, null));
        instructorViewModel.fetchInstructorByEmail(decodedToken['sub']);
        instructorViewModel.instructorBloc.stream.listen((state) {
          if (state is InstructorByEmailSuccessState) {
            loggedUser = LoggedUser(
              decodedToken['sub'],
              List<String>.from(decodedToken['roles']),
              loginResponse.accessToken,
              DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000, isUtc: true),
              null,
              state.instructor,
            );
            tokenManager.saveLoggedUser(loggedUser);
            Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!,
              Routes.instructorcourse,
                  (route) => false,
              arguments: state.instructor.instructorId.toString(),
            );
          }
        });
      } else if (decodedToken['roles'].contains('STUDENT')) {
        final studentDataSource = StudentDataSource(dio, tokenManager);
        final studentRepository = StudentRepositoryImpl(studentDataSource);
        final studentUseCases = StudentUsecase(studentRepository);
        final studentViewModel = Studentviewmodel(StudentBloc(studentUseCases, null));
        studentViewModel.fetchStudentByEmail(decodedToken['sub']);
        studentViewModel.studentBloc.stream.listen((state) {
          if (state is StudentByEmailSuccessState) {
            loggedUser = LoggedUser(
              decodedToken['sub'],
              List<String>.from(decodedToken['roles']),
              loginResponse.accessToken,
              DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000, isUtc: true),
              state.student,
              null,
            );
            tokenManager.saveLoggedUser(loggedUser);
            Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!,
              Routes.studentcourse,
                  (route) => false,
              arguments: state.student.studentId.toString(),
            );
          }
        });
      } else {
        // Navigate to the main route if no specific role is found
        Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!,
          Routes.mainRoute,
              (route) => false,
        );
      }
    }
    return response;
  }
}