import 'package:bloc/bloc.dart';
import '../../../domain/usecases/course_use_cases.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseUseCases _courseUseCases;
  CourseBloc(this._courseUseCases) : super(CourseInitial()) {
    on<SearchCoursesEvent>((event, emit) async {
      emit(CourseLoading());
      final result = await _courseUseCases.searchCourses(event.keyword, event.currentPage, event.pageSize);
      result.fold(
            (error) => emit(CourseError(error)),
            (response) => emit(CourseSuccess(response.content)),
      );
    });
    on<SaveCourseEvent>((event, emit) async {
      emit(CourseLoading());
      final result = await _courseUseCases.saveCourse(event.course);
      result.fold(
            (error) => emit(CourseError(error)),
            (course) => emit(CourseSuccessSave(course)),

      );
    });
    on<UpdateCourseEvent>((event, emit) async {
      emit(CourseLoading());
      final result = await _courseUseCases.updateCourse(event.course);
      result.fold(
            (error) => emit(CourseError(error)),
            (course) => emit(CourseSuccessUpdate(course)),

      );
    });
    on<DeleteCourseEvent>((event, emit) async {
      emit(CourseLoading());
      final result = await _courseUseCases.deleteCourse(event.courseId);
      result.fold(
            (error) => emit(CourseError(error)),
            (courseId) => emit(CourseSuccessDelete(courseId as int)),

      );
    });


  }



}