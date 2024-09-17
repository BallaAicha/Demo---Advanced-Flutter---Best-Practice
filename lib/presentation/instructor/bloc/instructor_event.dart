import 'package:equatable/equatable.dart';
import 'package:testeur/domain/model/instructor.dart';

abstract class InstructorEvent extends Equatable {
  const InstructorEvent();
  @override
  List<Object> get props => [];
}

class FetchInstructorsEvent extends InstructorEvent {
  const FetchInstructorsEvent();
}

class FetchInstructorByEmailEvent extends InstructorEvent {
  const FetchInstructorByEmailEvent(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}



class SearchInstructorsEvent extends InstructorEvent {
  const SearchInstructorsEvent(this.keyword, this.currentPage, this.pageSize);
  final String keyword;
  final int currentPage;
  final int pageSize;

  @override
  List<Object> get props => [keyword, currentPage, pageSize];
}

//getCoursesByInstructor
class GetCoursesByInstructorEvent extends InstructorEvent {
  const GetCoursesByInstructorEvent(this.instructorId, this.currentPage, this.pageSize);
  final int instructorId;
  final int currentPage;
  final int pageSize;

  @override
  List<Object> get props => [instructorId, currentPage, pageSize];
}

//saveStudent
class SaveInstructorEvent extends InstructorEvent {
  const SaveInstructorEvent(this.instructor);
  final Instructor instructor;

  @override
  List<Object> get props => [instructor];
}

//checkIfEmailExist
class CheckIfEmailExistEvent extends InstructorEvent {
  const CheckIfEmailExistEvent(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

//deleteInstructor
class DeleteInstructorEvent extends InstructorEvent {
  const DeleteInstructorEvent(this.instructorId);
  final int instructorId;

  @override
  List<Object> get props => [instructorId];
}

//getCoursesByInstructor
class GetCoursesByInstructor extends InstructorEvent {
  const GetCoursesByInstructor(this.instructorId, this.currentPage, this.pageSize);
  final int instructorId;
  final int currentPage;
  final int pageSize;

  @override
  List<Object> get props => [instructorId, currentPage, pageSize];
}

//updateInstructor
class UpdateInstructorEvent extends InstructorEvent {
  const UpdateInstructorEvent(this.instructor);
  final Instructor instructor;

  @override
  List<Object> get props => [instructor];
}