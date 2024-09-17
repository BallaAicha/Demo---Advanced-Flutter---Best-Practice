import 'package:equatable/equatable.dart';
import 'package:testeur/domain/model/course.dart';
abstract class CourseEvent extends Equatable {
  final String keyword;
  final int currentPage;
  final int pageSize;
  const CourseEvent(this.keyword, this.currentPage, this.pageSize);
  @override
  List<Object> get props => [keyword, currentPage, pageSize];
}

class SearchCoursesEvent extends CourseEvent {
  const SearchCoursesEvent(super.keyword, super.currentPage, super.pageSize);
}

class SaveCourseEvent extends CourseEvent {
  final Course course;
  const SaveCourseEvent(this.course) : super('', 0, 0);
  @override
  List<Object> get props => [course];
}


class UpdateCourseEvent extends CourseEvent {
  final Course course;
  const UpdateCourseEvent(this.course) : super('', 0, 0);

  @override List<Object> get props => [course];
}

class DeleteCourseEvent extends CourseEvent {
  final int courseId;
  const DeleteCourseEvent(this.courseId) : super('', 0, 0);
  @override
  List<Object> get props => [courseId];
}