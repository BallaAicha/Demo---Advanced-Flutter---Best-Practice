import 'package:dartz/dartz.dart';
import 'package:testeur/domain/repository/course_repository.dart';

import '../../domain/model/course.dart';
import '../../domain/model/page_response.dart';
import '../datasource/course_data_source.dart';

class CourseRepositoryImpl implements CourseRepository{
  final CourseDataSource  courseDataSource;
  CourseRepositoryImpl(this.courseDataSource);
  @override
  Future<Either<String, PageResponse<Course>>> searchCourses(String keyword, int currentPage, int pageSize) async {
    try {
      final response = await courseDataSource.searchCourses(keyword, currentPage, pageSize);
      return Right(response);
    } catch (e) {
      return Left('Error fetching courses: $e');
    }
  }


  @override
  Future<Either<String, Course>> saveCourse(Course course) async {
    try {
      final savedCourse = await courseDataSource.saveCourse(course);
      return Right(savedCourse);
    } catch (e) {
      return Left('Error saving course: $e');
    }
  }

  @override
  Future<Either<String, Course>> updateCourse(Course course) async{

    try {
      final updatedCourse = await courseDataSource.updateCourse(course);
      return Right(updatedCourse);
    } catch (e) {
      return Left('Error updating course: $e');
    }
  }

  @override
  Future<Either<String, String>> deleteCourse(int courseId) async {
    try {
      final response = await courseDataSource.deleteCourse(courseId);
      return Right(response);
    } catch (e) {
      return Left('Error deleting course: $e');
    }
  }
}