import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/page_response.dart';

import '../model/course.dart';
import '../model/student.dart';
import '../repository/student-repository.dart';

class  StudentUsecase {
  final StudentRepository _studentRepository;

  StudentUsecase(this._studentRepository);

  Future<Either<String, Student>> loadStudentByEmail(String email) {
    return _studentRepository.loadStudentByEmail(email);
  }

  //getCoursesByStudent
  Future<Either<String, PageResponsee<Course>>> getCoursesByStudent(String studentId, int currentPage, int pageSize) {
    return _studentRepository.getCoursesByStudent(studentId, currentPage, pageSize);
  }


  Future<Either<String, PageResponsee<Course>>> getNonEnrolledInCoursesByStudent(String studentId, int currentPage, int pageSize) {
    return _studentRepository.getNonEnrolledInCoursesByStudent(studentId, currentPage, pageSize);
  }

  Future<Either<String, Student>> updateStudent(Student student) {
    return _studentRepository.updateStudent(student);
  }

  Future<Either<String, bool>> enrollStudentInCourse(int courseId, int studentId) {
    return _studentRepository.enrollStudentInCourse(courseId, studentId);
  }


  }