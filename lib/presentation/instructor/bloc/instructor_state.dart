

import 'package:equatable/equatable.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/instructor.dart';

abstract class InstructorState  extends Equatable{}

class InstructorInitialState extends InstructorState {
  @override
  List<Object> get props => [];
}

class InstructorLoadingState extends InstructorState {
  @override
  List<Object> get props => [];
}

class InstructorSuccessState extends InstructorState {
  final List<dynamic> instructors;
  InstructorSuccessState(this.instructors);
  @override
  List<Object> get props => [instructors];
}

class InstructorErrorState extends InstructorState {
  final String message;
  InstructorErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class InstructorByEmailSuccessState extends InstructorState {
  final dynamic instructor;
  InstructorByEmailSuccessState(this.instructor);
  @override
  List<Object> get props => [instructor];
}


//searchInstructors
class SearchInstructorsSuccessState extends InstructorState {
  final List<Instructor> instructors;
  SearchInstructorsSuccessState(this.instructors);
  @override
  List<Object> get props => [instructors];
}


class GetCoursesByInstructorSuccessState extends InstructorState {
  final List<Course> courses;
  GetCoursesByInstructorSuccessState(this.courses);
  @override
  List<Object> get props => [courses];
}

class SaveInstructorSuccessState extends InstructorState {
  final Instructor instructor;
  SaveInstructorSuccessState(this.instructor);
  @override
  List<Object> get props => [instructor];
}
class EmailExistSuccessState extends InstructorState {
  final bool isExist;
  EmailExistSuccessState(this.isExist);
  @override
  List<Object> get props => [isExist];
}

//deleteInstructor
class DeleteInstructorSuccessState extends InstructorState {
  final int instructorId;
  DeleteInstructorSuccessState(this.instructorId);
  @override
  List<Object> get props => [instructorId];
}

//getCoursesByInstructor

class CoursesByInstructorSuccessState extends InstructorState {
  final List<Course> courses;
  CoursesByInstructorSuccessState(this.courses);
  @override
  List<Object> get props => [courses];
}

class InstructorUpdateSuccessState extends InstructorState {
  final Instructor instructor;
  InstructorUpdateSuccessState(this.instructor);
  @override
  List<Object> get props => [instructor];
}




