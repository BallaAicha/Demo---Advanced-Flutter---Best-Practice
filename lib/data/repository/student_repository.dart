import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/page_response.dart';

import 'package:testeur/domain/model/student.dart';

import '../../domain/repository/student-repository.dart';
import '../datasource/student_data_source.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentDataSource studentDataSource;

  StudentRepositoryImpl( this.studentDataSource);

  @override
  Future<Either<String, Student>> loadStudentByEmail(String email) async {
    try {
      final student = await studentDataSource.loadStudentByEmail(email);
      return Right(student);
    } catch (e) {
      return Left(e.toString());
    }

  }

  @override
  Future<Either<String, PageResponsee<Course>>> getCoursesByStudent(String studentId, int currentPage, int pageSize) async {

    {
      try {
        final courses = await studentDataSource.getCoursesByStudent(studentId, currentPage, pageSize);
        return Right(courses);
      } catch (e) {
        return Left(e.toString());
      }
    }
  }

  @override
  Future<Either<String, Student>> updateStudent(Student student) async{
    try {
      final updatedStudent = await studentDataSource.updateStudent(student);
      return Right(updatedStudent);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, PageResponsee<Course>>> getNonEnrolledInCoursesByStudent(String studentId, int currentPage, int pageSize) async{

    try {
      final courses = await  studentDataSource.getNonEnrolledInCoursesByStudent(studentId, currentPage, pageSize);
      return Right(courses);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> enrollStudentInCourse(int courseId, int studentId) async {
    try {
      final isEnrolled = await studentDataSource.enrollStudentInCourse(courseId, studentId);
      return Right(isEnrolled);
    } catch (e) {
      return Left(e.toString());
    }
  }




}