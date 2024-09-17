import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/page_response.dart';

import '../model/instructor.dart';

abstract class InstructorRepository{
  Future<Either<String, List<Instructor>>> findAllInstructors();
  Future<Either<String, Instructor>> loadInstructorByEmail(String email);
  //getCoursesByInstructor
  Future<Either<String, PageResponsee<Course>>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize);
  //updateInstructor
  Future<Either<String, Instructor>> updateInstructor(Instructor instructor);
}