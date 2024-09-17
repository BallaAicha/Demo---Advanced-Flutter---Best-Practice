import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/page_response.dart';
import 'package:testeur/domain/repository/course_repository.dart';


class CourseUseCases{
  final CourseRepository repository;
  CourseUseCases(this.repository);

  Future<Either<String,PageResponse<Course>>> searchCourses(String keyword, int currentPage, int pageSize){
    return repository.searchCourses(keyword, currentPage, pageSize);
  }

  Future<Either<String,Course>> saveCourse(Course course){
    return repository.saveCourse(course);
  }

  Future<Either<String,Course>> updateCourse(Course course){
    return repository.updateCourse(course);
  }

  Future<Either<String,String>> deleteCourse(int courseId){
    return repository.deleteCourse(courseId);
  }



}