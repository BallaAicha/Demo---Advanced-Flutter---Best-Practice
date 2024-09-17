import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:testeur/app/constant.dart';
import 'package:testeur/app/manager/token_manager.dart';
import 'package:testeur/domain/model/page_response.dart';
import 'package:testeur/domain/model/student.dart';

class AdminStudentDataSource{
  final Dio dio;
  final TokenManager tokenManager;

  AdminStudentDataSource(this.dio, this.tokenManager);

  Future<PageResponsee<Student>> searchStudents(String keyword, int currentPage, int pageSize) async {
   try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/students',
        queryParameters: {
          'keyword': keyword,
          'page': currentPage,
          'size': pageSize,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return PageResponsee.fromJson(response.data, (json) => Student.fromJson(json));
    } catch (e) {
     if (kDebugMode) {
       print('Error fetching courses: $e');
     }
     rethrow;
   }

  }

  Future<String> deleteStudent(int studentId) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.delete(
        '${Constant.baseUrl}/students/$studentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return 'Success';
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting student: $e');
      }
      rethrow;
    }
  }

  Future<Student> saveStudent(Student student) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.post(
        '${Constant.baseUrl}/students',
        data: student.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return Student.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving student: $e');
      }
      rethrow;
    }
  }


  Future<bool> checkIfEmailExist(String email) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/users',
        queryParameters: {
          'email': email,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return response.data as bool;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking email: $e');
      }
      rethrow;
    }
  }
}