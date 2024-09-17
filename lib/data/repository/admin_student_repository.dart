import 'package:dartz/dartz.dart';

import 'package:testeur/domain/model/page_response.dart';

import 'package:testeur/domain/model/student.dart';

import '../../domain/repository/admin_student_repository.dart';
import '../datasource/admin_student_data_source.dart';

class AdminStudentRepositoryImpl implements AdminStudentRepository{
  final AdminStudentDataSource adminStudentDataSource;

  AdminStudentRepositoryImpl(this.adminStudentDataSource);

  @override
  Future<Either<String, PageResponsee<Student>>> searchStudents(String keyword, int currentPage, int pageSize) async{
   try{
     final students = await adminStudentDataSource.searchStudents(keyword, currentPage, pageSize);
      return Right(students);
   }
    catch(e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> deleteStudent(int studentId) async {
    try{
      final response = await adminStudentDataSource.deleteStudent(studentId);
      return Right(response);
    }
    catch(e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Student>> saveStudent(Student student) async {
    try{
      final response = await adminStudentDataSource.saveStudent(student);
      return Right(response);
    }
    catch(e){
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> checkIfEmailExist(String email) async {
    try{
      final response = await adminStudentDataSource.checkIfEmailExist(email);
      return Right(response);
    }
    catch(e){
      return Left(e.toString());
    }
  }





}