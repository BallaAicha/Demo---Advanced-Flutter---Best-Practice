import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/instructor.dart';

import '../model/page_response.dart';

abstract class AdminInstructorRepository{
  Future<Either<String,PageResponsee<Instructor>>> searchInstructors(String keyword, int currentPage, int pageSize);

  Future<Either<String,PageResponsee<Course>>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize);

  Future<Either<String,Instructor>> saveInstructor(Instructor instructor);

  Future<Either<String,bool>> checkIfEmailExist(String email);

  Future<Either<String,String>> deleteInstructor(int instructorId);
}