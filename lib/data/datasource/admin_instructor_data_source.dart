import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/instructor.dart';

import '../../app/constant.dart';
import '../../app/manager/token_manager.dart';
import '../../domain/model/page_response.dart';

class AdminInstructorDataSource{
  final Dio dio;
  final TokenManager tokenManager;

  AdminInstructorDataSource(this.dio, this.tokenManager);
  Future<PageResponsee<Instructor>> searchInstructors(String keyword, int currentPage, int pageSize) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/instructors',
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
      return PageResponsee.fromJson(response.data, (json) => Instructor.fromJson(json));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      rethrow;
    }

  }

  Future<PageResponsee<Course>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/instructors/$instructorId/courses',
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
      return  PageResponsee.fromJson(response.data, (json) => Course.fromJson(json));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      rethrow;
    }

  }

  Future<Instructor> saveInstructor(Instructor instructor) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.post(
        '${Constant.baseUrl}/instructors',
        data: instructor.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return Instructor.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving student: $e');
      }
      rethrow;
    }
  }

  //deleteInstructor
  Future<String> deleteInstructor(int instructorId) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.delete(
        '${Constant.baseUrl}/instructors/$instructorId',
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