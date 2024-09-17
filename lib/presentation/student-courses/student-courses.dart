import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/data/datasource/student_data_source.dart';
import 'package:testeur/data/repository/student_repository.dart';
import 'package:testeur/domain/repository/student-repository.dart';
import 'package:testeur/presentation/course/widgets/course_card.dart';
import 'package:testeur/presentation/student-courses/widgets/course_card_student.dart';
import '../../app/manager/token_manager.dart';
import '../../domain/model/course.dart';
import '../../domain/model/logged_user.dart';
import '../../domain/model/page_response.dart';
import '../../domain/usecases/student_usecase.dart';
import '../setting/settingview.dart';
import '../student/bloc/student_bloc.dart';
import '../student/bloc/student_state.dart';
import '../student/viewmodel/student-viewmodel.dart';
import '../ressources/colors_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StudentCourses extends StatefulWidget {
  final String studentId;

  const StudentCourses({super.key, required this.studentId});

  @override
  State<StudentCourses> createState() => _StudentCoursesState();
}

class _StudentCoursesState extends State<StudentCourses> {
  late Studentviewmodel _studentViewModel;
  late Dio dio;
  late TokenManager tokenManager;
  int _currentIndex = 0;
  LoggedUser? _loggedUser;

  @override
  void initState() {
    super.initState();

    // Initialize Dio and TokenManager
    dio = Dio();
    tokenManager = TokenManager();

    // Data source
    final studentDataSource = StudentDataSource(dio, tokenManager);
    // Create an instance of StudentRepositoryImpl
    final studentRepository = StudentRepositoryImpl(studentDataSource);

    final studentUseCases = StudentUsecase(studentRepository);

    final studentBloc = StudentBloc(studentUseCases, null);
    _studentViewModel = Studentviewmodel(studentBloc);
    _studentViewModel.fetchNonEnrolledInCoursesByStudent(widget.studentId, 0, 10);

    _loadLoggedUser();
  }

  Future<void> _loadLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedUserJson = prefs.getString('loggedUser');
    if (loggedUserJson != null) {
      setState(() {
        _loggedUser = LoggedUser.fromJson(jsonDecode(loggedUserJson));
      });
    }
  }

  @override
  void dispose() {
    _studentViewModel.studentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? _buildCoursesView()
          : _currentIndex == 1
          ? _buildEnrolledCoursesView()
          : _buildProfileView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              _studentViewModel.fetchNonEnrolledInCoursesByStudent(widget.studentId, 0, 10);
            } else if (_currentIndex == 1) {
              _studentViewModel.fetchCoursesByStudent(widget.studentId, 0, 10);
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Enrolled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesView() {
    return BlocBuilder<StudentBloc, StudentState>(
      bloc: _studentViewModel.studentBloc,
      builder: (context, state) {
        if (state is StudentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NonEnrolledInCoursesByStudentSuccessState) {
          if (state.courses.content.isEmpty) {
            return const Center(child: Text('Aucun cours disponible pour le moment'));
          }
          return _buildCoursesList(state.courses, false);
        } else if (state is StudentErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Aucun données pour le moment'));
        }
      },
    );
  }

  Widget _buildEnrolledCoursesView() {
    return BlocBuilder<StudentBloc, StudentState>(
      bloc: _studentViewModel.studentBloc,
      builder: (context, state) {
        if (state is StudentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CoursesByStudentSuccessState) {
          if (state.courses.content.isEmpty) {
            return const Center(child: Text('Aucun cours inscrit pour le moment'));
          }
          return _buildCoursesList(state.courses, true);
        } else if (state is StudentErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Aucun données pour le moment'));
        }
      },
    );
  }

  Widget _buildProfileView() {
    if (_loggedUser != null) {
      return SettingView(loggedUser: _loggedUser!);
    } else {
      return const Center(
        child: Text(
          'No logged user',
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      );
    }
  }

  Widget _buildCoursesList(PageResponsee<Course> courses, bool isEnrolled) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorManager.gradientStart,
            ColorManager.gradientEnd,
          ],
        ),
      ),
      child: ListView.builder(
        itemCount: courses.content.length,
        itemBuilder: (context, index) {
          final course = courses.content[index];
          return CourseCardStudent(
            courseName: course.courseName,
            courseDuration: course.courseDuration,
            courseDescription: course.courseDescription,
            instructorName: '${course.instructor!.firstName} ${course.instructor!.lastName}',
            instructorSummary: course.instructor!.summary,
            course: course,
            isEnrolled: isEnrolled,
          );
        },
      ),
    );
  }
}