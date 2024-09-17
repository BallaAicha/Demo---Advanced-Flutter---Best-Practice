import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:testeur/domain/model/student.dart';

import '../../app/constant.dart';
import '../../app/manager/token_manager.dart';
import '../../domain/model/course.dart';
import '../../domain/model/page_response.dart';

class StudentDataSource{
  final Dio dio;
  final TokenManager tokenManager;

  StudentDataSource(this.dio, this.tokenManager);

  Future<Student> loadStudentByEmail(String email) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/students/find',
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
      return Student.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading instructor: $e');
      }
      rethrow;
    }
  }

  Future<PageResponsee<Course>> getCoursesByStudent(String studentId, int currentPage, int pageSize) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/students/$studentId/courses',
        queryParameters: {
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
      return PageResponsee.fromJson(response.data, (json) => Course.fromJson(json));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      rethrow;
    }
  }


  Future<PageResponsee<Course>> getNonEnrolledInCoursesByStudent(String studentId, int currentPage, int pageSize) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/students/$studentId/other-courses',
        queryParameters: {
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
      return PageResponsee.fromJson(response.data, (json) => Course.fromJson(json));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching non-enrolled courses: $e');
      }
      rethrow;
    }
  }

  Future<Student> updateStudent(Student student) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.put(
        '${Constant.baseUrl}/students/${student.studentId}',
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
        print('Error updating student: $e');
      }
      rethrow;
    }
  }

  Future<bool> enrollStudentInCourse(int courseId, int studentId) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.post(
        '${Constant.baseUrl}/$courseId/enroll/students/$studentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error enrolling student in course: $e');
      }
      rethrow;
    }
  }

}