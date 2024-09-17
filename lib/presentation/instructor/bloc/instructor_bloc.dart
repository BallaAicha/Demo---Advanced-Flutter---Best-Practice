import 'package:bloc/bloc.dart';

import '../../../domain/usecases/admin_instructor_usecase.dart';
import '../../../domain/usecases/instructor_usecase.dart';
import 'instructor_event.dart';
import 'instructor_state.dart';


class InstructorBloc extends Bloc<InstructorEvent, InstructorState> {
  final InstructorUseCases instructorUseCases;
  final AdminInstructorUsecase? adminInstructorUseCases;

  InstructorBloc(this.instructorUseCases,this.adminInstructorUseCases) : super(InstructorInitialState()) {
    on<InstructorEvent>((event, emit)  async{
      emit(InstructorLoadingState());
      final result = await instructorUseCases.findAllInstructors();
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (instructors) => emit(InstructorSuccessState(instructors)),
      );
    });

    on<FetchInstructorByEmailEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await instructorUseCases.loadInstructorByEmail(event.email);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (instructor) => emit(InstructorByEmailSuccessState(instructor)),
      );
    });

    on<SearchInstructorsEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await adminInstructorUseCases!.searchInstructors(event.keyword, event.currentPage, event.pageSize);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (instructors) => emit(SearchInstructorsSuccessState(instructors.content)),
      );
    });

    on<GetCoursesByInstructorEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await adminInstructorUseCases!.getCoursesByInstructor(event.instructorId, event.currentPage, event.pageSize);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (courses) => emit(GetCoursesByInstructorSuccessState(courses.content)),
      );
    });

    on<SaveInstructorEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await adminInstructorUseCases!.saveInstructor(event.instructor);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (instructor) => emit(SaveInstructorSuccessState(instructor)),
      );
    });
    on<CheckIfEmailExistEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await adminInstructorUseCases!.checkIfEmailExist(event.email);
      result.fold(
            (error) => emit(InstructorErrorState(error)),
            (isExist) => emit(EmailExistSuccessState(isExist)),
      );
    });

    //deleteInstructor
    on<DeleteInstructorEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await adminInstructorUseCases!.deleteInstructor(event.instructorId);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (instructorId) => emit(DeleteInstructorSuccessState(instructorId as int)),
      );
    });

    //getCoursesByInstructor
    on<GetCoursesByInstructor>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await instructorUseCases.getCoursesByInstructor(event.instructorId, event.currentPage, event.pageSize);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (courses) => emit(CoursesByInstructorSuccessState(courses.content)),
      );
    });

    //updateInstructor
    on<UpdateInstructorEvent>((event, emit) async {
      emit(InstructorLoadingState());
      final result = await instructorUseCases.updateInstructor(event.instructor);
      result.fold(
        (error) => emit(InstructorErrorState(error)),
        (instructor) => emit(InstructorUpdateSuccessState(instructor)),
      );
    });
  }

}
