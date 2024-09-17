import 'package:testeur/presentation/course/bloc/course_bloc.dart';

import '../../../domain/model/course.dart';
import '../bloc/course_event.dart';

class CourseViewmodel{
  final CourseBloc courseBloc;

  CourseViewmodel(this.courseBloc);

  void searchCourses(String keyword, int currentPage, int pageSize){
    courseBloc.add(SearchCoursesEvent(keyword, currentPage, pageSize));
  }

  void saveCourse(Course course) {
    courseBloc.add(SaveCourseEvent(course));
    courseBloc.add(const SearchCoursesEvent('', 0, 10));

  }

  void updateCourse(Course course) {
    courseBloc.add(UpdateCourseEvent(course));
    courseBloc.add(const SearchCoursesEvent('', 0, 10));
  }

  void deleteCourse(int courseId) {
    courseBloc.add(DeleteCourseEvent(courseId));
    courseBloc.add(const SearchCoursesEvent('', 0, 10));
  }

}