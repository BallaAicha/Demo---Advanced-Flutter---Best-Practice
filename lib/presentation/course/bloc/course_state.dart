import 'package:equatable/equatable.dart';
import '../../../domain/model/course.dart';
abstract class CourseState extends Equatable  {
  const CourseState();
  @override
  List<Object> get props => [];
}
final class CourseInitial extends CourseState {}
final class CourseLoading extends CourseState {}
final class CourseSuccess extends CourseState {
  final List<Course> courses;
  const CourseSuccess(this.courses);
  @override
  List<Object> get props => [courses];
}
final class CourseError extends CourseState {
  final String message;
  const CourseError(this.message);
  @override
  List<Object> get props => [message];
}
class CourseSuccessSave extends CourseState {
  final Course course;
  const CourseSuccessSave(this.course);
  @override
  List<Object> get props => [course];
}
class CourseSuccessUpdate extends CourseState {
  final Course course;
  const CourseSuccessUpdate(this.course);
  @override
  List<Object> get props => [course];
}
class CourseSuccessDelete extends CourseState {
  final int courseId;
  const CourseSuccessDelete(this.courseId);
  @override
  List<Object> get props => [courseId];
}
