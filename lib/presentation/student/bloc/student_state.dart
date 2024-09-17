import 'package:equatable/equatable.dart';
import 'package:testeur/domain/model/student.dart';

abstract class StudentState  extends Equatable{}

class StudentInitial extends StudentState {
  @override
  List<Object> get props => [];
}

class StudentLoading extends StudentState {
  @override
  List<Object> get props => [];
}

//error state
class StudentErrorState extends StudentState {
  final String message;
  StudentErrorState(this.message);
  @override
  List<Object> get props => [message];
}



class StudentByEmailSuccessState extends StudentState {
  final dynamic student;
  StudentByEmailSuccessState(this.student);
  @override
  List<Object> get props => [student];

}

class CoursesByStudentSuccessState extends StudentState {
  final dynamic courses;
  CoursesByStudentSuccessState(this.courses);
  @override
  List<Object> get props => [courses];
}


class StudentUpdateSuccessState extends StudentState {
  final Student student;
  StudentUpdateSuccessState(this.student);
  @override
  List<Object> get props => [student];
}

class NonEnrolledInCoursesByStudentSuccessState extends StudentState {
  final dynamic courses;
  NonEnrolledInCoursesByStudentSuccessState(this.courses);
  @override
  List<Object> get props => [courses];
}

class StudentEnrolledInCourseSuccessState extends StudentState {
  final bool isEnrolled;
  StudentEnrolledInCourseSuccessState(this.isEnrolled);
  @override
  List<Object> get props => [isEnrolled];
}

class StudentsSearchSuccessState extends StudentState {
  final List<Student> students;
  StudentsSearchSuccessState(this.students);
  @override
  List<Object> get props => [students];
}

class StudentDeletedSuccessState extends StudentState {
  final int studentId;
  StudentDeletedSuccessState(this.studentId);
  @override
  List<Object> get props => [studentId];
}

class StudentSavedSuccessState extends StudentState {
  final Student student;
  StudentSavedSuccessState(this.student);
  @override
  List<Object> get props => [student];
}

class EmailExistSuccessState extends StudentState {
  final bool isExist;
  EmailExistSuccessState(this.isExist);
  @override
  List<Object> get props => [isExist];
}

