import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';

import 'package:testeur/domain/model/instructor.dart';

import 'package:testeur/domain/model/page_response.dart';

import '../../domain/repository/admin_instructor_repository.dart';
import '../datasource/admin_instructor_data_source.dart';

class AdminInstructorRepositoryImpl implements AdminInstructorRepository{
  final AdminInstructorDataSource adminInstructorDataSource;

  AdminInstructorRepositoryImpl(this.adminInstructorDataSource);

  @override
  Future<Either<String, PageResponsee<Instructor>>> searchInstructors(String keyword, int currentPage, int pageSize) async {
    try{
      final response = await adminInstructorDataSource.searchInstructors(keyword, currentPage, pageSize);
      return Right(response);
    } catch(e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, PageResponsee<Course>>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize) async {
    try{
      final response = await adminInstructorDataSource.getCoursesByInstructor(instructorId, currentPage, pageSize);
      return Right(response);
    } catch(e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> checkIfEmailExist(String email)async {
    try{
      final response = await adminInstructorDataSource.checkIfEmailExist(email);
      return Right(response);
    }
    catch(e){
      return Left(e.toString());
    }


  }

  @override
  Future<Either<String, Instructor>> saveInstructor(Instructor instructor) async {
    try{
      final response = await adminInstructorDataSource.saveInstructor(instructor);
      return Right(response);
    }
    catch(e){
      return Left(e.toString());
    }

  }

  @override
  Future<Either<String, String>> deleteInstructor(int instructorId) async{
    try{
      final response = await adminInstructorDataSource.deleteInstructor(instructorId);
      return Right(response);
    }
    catch(e){
      return Left(e.toString());
    }
  }
}