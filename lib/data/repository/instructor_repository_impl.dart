import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/instructor.dart';
import 'package:testeur/domain/model/page_response.dart';
import 'package:testeur/domain/repository/instructor_repository.dart';

import '../datasource/instructor_data_source.dart';

class InstructorRepositoryImpl implements InstructorRepository{
  final InstructorDataSource _instructorDataSource;


  InstructorRepositoryImpl(this._instructorDataSource);

  @override
  Future<Either<String, List<Instructor>>> findAllInstructors() async {
    try {
      final instructors = await _instructorDataSource.findAllInstructors();
      return Right(instructors);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Instructor>> loadInstructorByEmail(String email) async {
    try {
      final instructor = await _instructorDataSource.loadInstructorByEmail(email);
      return Right(instructor);
    } catch (e) {
      return Left(e.toString());
    }


  }

  @override
  Future<Either<String, PageResponsee<Course>>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize) async{
    try {
      final courses = await _instructorDataSource.getCoursesByInstructor(instructorId, currentPage, pageSize);
      return Right(courses);
    } catch (e) {
      return Left(e.toString());
    }

  }

  @override
  Future<Either<String, Instructor>> updateInstructor(Instructor instructor) async{
    try {
      final updatedInstructor = await _instructorDataSource.updateInstructor(instructor);
      return Right(updatedInstructor);
    } catch (e) {
      return Left(e.toString());
    }
  }
}