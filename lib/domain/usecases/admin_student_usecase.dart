import 'package:dartz/dartz.dart';

import '../model/page_response.dart';
import '../model/student.dart';
import '../repository/admin_student_repository.dart';

class AdminStudentUsecase {
  final AdminStudentRepository repository;

  AdminStudentUsecase(this.repository);

  Future<Either<String,PageResponsee<Student>>> searchStudents(String keyword, int currentPage, int pageSize) {
    return repository.searchStudents(keyword, currentPage, pageSize);
  }
  Future<Either<String,String>> deleteStudent(int studentId) {
    return repository.deleteStudent(studentId);
  }
  Future<Either<String, Student>> saveStudent(Student student) async {
    // Validate email format
    if (student.user?.email == null || student.user?.email.isEmpty == true) {
      return const Left('Email is required');
    }
    // Check if email already exists
    final emailExistsResult = await repository.checkIfEmailExist(student.user?.email ?? '');
    return emailExistsResult.fold(
          (error) => Left(error),
          (emailExists) {
        if (emailExists) {
          return const Left('Email already exists');
        } else {
          return repository.saveStudent(student);
        }
      },
    );
  }
  Future<Either<String,bool>> checkIfEmailExist(String email) {
    return repository.checkIfEmailExist(email);
  }



}