import 'package:bloc/bloc.dart';
import 'package:testeur/domain/usecases/student_usecase.dart';
import 'package:testeur/presentation/student/bloc/student_event.dart';
import 'package:testeur/presentation/student/bloc/student_state.dart';

import '../../../domain/usecases/admin_student_usecase.dart';


class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentUsecase studentUseCases;
  final AdminStudentUsecase? adminStudentUsecase;
  StudentBloc(
    this.studentUseCases,
    this.adminStudentUsecase,
      ) : super(StudentInitial()) {
    on<FetchStudentByEmailEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await studentUseCases.loadStudentByEmail(event.email);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (instructor) => emit(StudentByEmailSuccessState(instructor)),
      );
    });

    on<FetchCoursesByStudentEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await studentUseCases.getCoursesByStudent(event.studentId, event.currentPage, event.pageSize);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (courses) => emit(CoursesByStudentSuccessState(courses)),
      );
    });

    on<UpdateStudentEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await studentUseCases.updateStudent(event.student);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (student) => emit(StudentUpdateSuccessState(student)),
      );
    });

    on<FetchNonEnrolledInCoursesByStudentEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await studentUseCases.getNonEnrolledInCoursesByStudent(event.studentId, event.currentPage, event.pageSize);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (courses) => emit(NonEnrolledInCoursesByStudentSuccessState(courses)),
      );
    });

    on<EnrollStudentInCourseEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await studentUseCases.enrollStudentInCourse(event.courseId, event.studentId);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (isEnrolled) => emit(StudentEnrolledInCourseSuccessState(isEnrolled)),
      );
    });

    on<SearchStudentsEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await adminStudentUsecase!.searchStudents(event.keyword, event.currentPage, event.pageSize);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (studentsPageResponse) => emit(StudentsSearchSuccessState(studentsPageResponse.content)),
      );
    });

    //deleteStudent
    on<DeleteStudentEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await adminStudentUsecase!.deleteStudent(event.studentId);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (studentId) => emit(StudentDeletedSuccessState(studentId as int)),
      );
    });

    //saveStudent
    on<SaveStudentEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await adminStudentUsecase!.saveStudent(event.student);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (student) => emit(StudentSavedSuccessState(student)),
      );
    });

    on<CheckIfEmailExistEvent>((event, emit) async {
      emit(StudentLoading());
      final result = await adminStudentUsecase!.checkIfEmailExist(event.email);
      result.fold(
            (error) => emit(StudentErrorState(error)),
            (isExist) => emit(EmailExistSuccessState(isExist)),
      );
    });
  }
}
