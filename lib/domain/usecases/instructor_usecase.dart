import 'package:dartz/dartz.dart';
import 'package:testeur/domain/repository/instructor_repository.dart';

import '../model/course.dart';
import '../model/instructor.dart';
import '../model/page_response.dart';

class InstructorUseCases{
  final  InstructorRepository _instructorRepository;
  InstructorUseCases(this._instructorRepository);

  Future<Either<String, List<Instructor>>> findAllInstructors(){
    return _instructorRepository.findAllInstructors();
  }

  Future<Either<String, Instructor>> loadInstructorByEmail(String email){
    return _instructorRepository.loadInstructorByEmail(email);
  }

  Future<Either<String, PageResponsee<Course>>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize){
    return _instructorRepository.getCoursesByInstructor(instructorId, currentPage, pageSize);
  }

  Future<Either<String, Instructor>> updateInstructor(Instructor instructor){
    return _instructorRepository.updateInstructor(instructor);
  }

}