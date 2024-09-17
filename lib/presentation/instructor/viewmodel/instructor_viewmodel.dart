import '../../../domain/model/instructor.dart';
import '../bloc/instructor_bloc.dart';
import '../bloc/instructor_event.dart';

class InstructorViewmodel {
  final InstructorBloc instructorBloc;

  InstructorViewmodel(this.instructorBloc);

  void fetchInstructors() {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(const FetchInstructorsEvent());
    }
  }

  void fetchInstructorByEmail(String email) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(FetchInstructorByEmailEvent(email));
    }
  }

  void searchInstructors(String keyword, int currentPage, int pageSize) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(SearchInstructorsEvent(keyword, currentPage, pageSize));
    }
  }

  void getCoursesByInstructor(int instructorId, int currentPage, int pageSize) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(GetCoursesByInstructorEvent(instructorId, currentPage, pageSize));
    }
  }

  void saveInstructor(Instructor instructor) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(SaveInstructorEvent(instructor));
    }
  }

  void checkIfEmailExist(String email) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(CheckIfEmailExistEvent(email));
    }
  }

  void deleteInstructor(int instructorId) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(DeleteInstructorEvent(instructorId));
    }
  }

  void getCoursesByInstructors(int instructorId, int currentPage, int pageSize) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(GetCoursesByInstructor(instructorId, currentPage, pageSize));
    }
  }

  void updateInstructor(Instructor instructor) {
    if (!instructorBloc.isClosed) {
      instructorBloc.add(UpdateInstructorEvent(instructor));
    }
  }
}