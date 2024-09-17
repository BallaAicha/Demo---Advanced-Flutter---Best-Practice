import '../../../domain/model/student.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';

class Studentviewmodel{
  final StudentBloc studentBloc;

  Studentviewmodel(this.studentBloc);

  void fetchStudentByEmail(String email){
    studentBloc.add(FetchStudentByEmailEvent(email));
  }

  void fetchCoursesByStudent(String studentId, int currentPage, int pageSize){
    studentBloc.add(FetchCoursesByStudentEvent(studentId, currentPage, pageSize));
  }

  void updateStudent(Student student){
    studentBloc.add(UpdateStudentEvent(student));
  }

  void fetchNonEnrolledInCoursesByStudent(String studentId, int currentPage, int pageSize){
    studentBloc.add(FetchNonEnrolledInCoursesByStudentEvent(studentId, currentPage, pageSize));
  }

  void enrollStudentInCourse(int courseId, int studentId){
    studentBloc.add(EnrollStudentInCourseEvent(courseId, studentId));
  }

  //SearchStudentsEvent
  void searchStudents(String keyword, int currentPage, int pageSize){
    studentBloc.add(SearchStudentsEvent(keyword, currentPage, pageSize));
  }


  //deleteStudent

void deleteStudent(int studentId){
    studentBloc.add(DeleteStudentEvent(studentId));
  }

  //save student
  void saveStudent(Student student){
    studentBloc.add(SaveStudentEvent(student));
  }

  //checkIfEmailExist
  void checkIfEmailExist(String email){
    studentBloc.add(CheckIfEmailExistEvent(email));
  }



}