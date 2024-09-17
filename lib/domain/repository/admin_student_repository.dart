import 'package:dartz/dartz.dart';

import '../model/page_response.dart';
import '../model/student.dart';

abstract class AdminStudentRepository{
  Future<Either<String,PageResponsee<Student>>> searchStudents(String keyword, int currentPage, int pageSize);
  Future<Either<String,String>> deleteStudent(int studentId);
  Future<Either<String,Student>> saveStudent(Student student);
  Future<Either<String,bool>> checkIfEmailExist(String email);



}