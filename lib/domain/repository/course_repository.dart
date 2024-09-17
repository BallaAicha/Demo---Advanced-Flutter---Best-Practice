import 'package:dartz/dartz.dart';

import '../model/course.dart';
import '../model/page_response.dart';

abstract class CourseRepository{
  Future<Either<String,PageResponse<Course>>> searchCourses(String keyword, int currentPage, int pageSize);
  Future<Either<String,Course>> saveCourse(Course course);
  Future<Either<String,Course>> updateCourse(Course course);
  Future<Either<String,String>> deleteCourse(int courseId);
}