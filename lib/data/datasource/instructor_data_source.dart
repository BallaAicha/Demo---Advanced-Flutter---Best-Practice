import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:testeur/app/manager/token_manager.dart';

import '../../app/constant.dart';
import '../../domain/model/course.dart';
import '../../domain/model/instructor.dart';
import '../../domain/model/page_response.dart';

class InstructorDataSource{
  final Dio dio;
  final TokenManager tokenManager;

  InstructorDataSource(this.dio, this.tokenManager);

  Future<List<Instructor>> findAllInstructors() async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/instructors/all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return (response.data as List).map((json) => Instructor.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching instructors: $e');
      }
      rethrow;
    }
  }

  Future<Instructor> loadInstructorByEmail(String email) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        '${Constant.baseUrl}/instructors/find',
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
      return Instructor.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading instructor: $e');
      }
      rethrow;
    }
  }

  Future<PageResponsee<Course>> getCoursesByInstructor(int instructorId,int currentPage,int pageSize) async {
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
      return PageResponsee.fromJson(response.data, (json) => Course.fromJson(json));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses by instructor: $e');
      }
      rethrow;
    }
  }

  Future<Instructor> updateInstructor(Instructor instructor) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.put(
        '${Constant.baseUrl}/instructors/${instructor.instructorId}',
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
        print('Error updating instructor: $e');
      }
      rethrow;
    }
  }
}