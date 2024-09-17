import 'package:equatable/equatable.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/student.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
  @override
  List<Object> get props => [];
}

class FetchStudentByEmailEvent extends StudentEvent {
  const FetchStudentByEmailEvent(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

class FetchCoursesByStudentEvent extends StudentEvent {
  const FetchCoursesByStudentEvent(this.studentId, this.currentPage, this.pageSize);
  final String studentId;
  final int currentPage;
  final int pageSize;

  @override
  List<Object> get props => [studentId, currentPage, pageSize];
}

class UpdateStudentEvent extends StudentEvent {
  const UpdateStudentEvent(this.student);
  final Student student;

  @override
  List<Object> get props => [student];
}

class FetchNonEnrolledInCoursesByStudentEvent extends StudentEvent {
  const FetchNonEnrolledInCoursesByStudentEvent(this.studentId, this.currentPage, this.pageSize);
  final String studentId;
  final int currentPage;
  final int pageSize;

  @override
  List<Object> get props => [studentId, currentPage, pageSize];
}

class EnrollStudentInCourseEvent extends StudentEvent {
  const EnrollStudentInCourseEvent(this.courseId, this.studentId);
  final int courseId;
  final int studentId;

  @override
  List<Object> get props => [courseId, studentId];
}

//searchStudents
class SearchStudentsEvent extends StudentEvent {
  const SearchStudentsEvent(this.keyword, this.currentPage, this.pageSize);
  final String keyword;
  final int currentPage;
  final int pageSize;

  @override
  List<Object> get props => [keyword, currentPage, pageSize];
}

//deleteStudent
class DeleteStudentEvent extends StudentEvent {
  const DeleteStudentEvent(this.studentId);
  final int studentId;

  @override
  List<Object> get props => [studentId];
}

//saveStudent
class SaveStudentEvent extends StudentEvent {
  const SaveStudentEvent(this.student);
  final Student student;

  @override
  List<Object> get props => [student];
}

//checkIfEmailExist
class CheckIfEmailExistEvent extends StudentEvent {
  const CheckIfEmailExistEvent(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}