import 'package:dartz/dartz.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:testeur/domain/model/instructor.dart';

import '../model/page_response.dart';
import '../model/student.dart';
import '../repository/admin_instructor_repository.dart';

class AdminInstructorUsecase{
 final AdminInstructorRepository adminInstructorRepository;

 AdminInstructorUsecase(this.adminInstructorRepository);
 Future<Either<String,PageResponsee<Instructor>>> searchInstructors(String keyword, int currentPage, int pageSize) {
   return adminInstructorRepository.searchInstructors(keyword, currentPage, pageSize);
 }

  Future<Either<String,PageResponsee<Course>>> getCoursesByInstructor(int instructorId, int currentPage, int pageSize) {
    return adminInstructorRepository.getCoursesByInstructor(instructorId, currentPage, pageSize);
  }

 Future<Either<String, Instructor>> saveInstructor(Instructor instructor) async {
   // Validate email format
   if (instructor.user?.email == null || instructor.user?.email.isEmpty == true) {
     return const Left('Email is required');
   }
   // Check if email already exists
   final emailExistsResult = await adminInstructorRepository.checkIfEmailExist(instructor.user?.email ?? '');
   return emailExistsResult.fold(
         (error) => Left(error),
         (emailExists) {
       if (emailExists) {
         return const Left('Email already exists');
       } else {
         return adminInstructorRepository.saveInstructor(instructor);
       }
     },
   );
 }
 Future<Either<String,bool>> checkIfEmailExist(String email) {
   return adminInstructorRepository.checkIfEmailExist(email);
 }
  Future<Either<String,String>> deleteInstructor(int instructorId) {
    return adminInstructorRepository.deleteInstructor(instructorId);
  }
}