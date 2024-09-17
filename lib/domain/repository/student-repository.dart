import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/page_response.dart';
import 'package:testeur/domain/model/student.dart';

abstract class StudentRepository {

  Future<Either<String, Student>> loadStudentByEmail(String email);
Future<Either<String, PageResponsee<Course>>> getCoursesByStudent(String studentId, int currentPage, int pageSize);
Future<Either<String, Student>> updateStudent(Student student);

Future<Either<String, PageResponsee<Course>>> getNonEnrolledInCoursesByStudent(String studentId, int currentPage, int pageSize);


Future<Either<String, bool>> enrollStudentInCourse(int courseId, int studentId);


}