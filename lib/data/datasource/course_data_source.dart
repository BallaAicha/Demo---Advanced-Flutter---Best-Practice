import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../app/constant.dart';
import '../../app/manager/token_manager.dart';
import '../../domain/model/course.dart';
import '../../domain/model/page_response.dart';
class CourseDataSource {
  final Dio dio;
  final TokenManager tokenManager;
  CourseDataSource(this.dio, this.tokenManager);
  Future<PageResponse<Course>> searchCourses(
      String keyword, int currentPage, int pageSize) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.get(
        Constant.baseUrl,
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
      return PageResponse.fromJson(response.data, (json) => Course.fromJson(json));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      rethrow;
    }
  }

  Future<Course> saveCourse(Course course) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.post(
        Constant.baseUrl,
        data: course.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return Course.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving course: $e');
      }
      rethrow;
    }
  }


  Future<Course> updateCourse(Course course) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.put(
        '${Constant.baseUrl}/${course.courseId}',
        data: course.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return Course.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating course: $e');
      }
      rethrow;
    }
  }

  Future<String> deleteCourse(int courseId) async {
    try {
      final accessToken = await tokenManager.getAccessToken();
      final response = await dio.delete(
        '${Constant.baseUrl}/$courseId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (kDebugMode) {
        print('Response data: ${response.data}');
      }
      return 'Course deleted';
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting course: $e');
      }
      rethrow;
    }
  }
}
