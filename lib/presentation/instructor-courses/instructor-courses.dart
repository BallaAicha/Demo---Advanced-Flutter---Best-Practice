import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/instructor-courses/widgets/CourseModalInstructor.dart';
import 'package:testeur/presentation/instructor/widgets/CourseCardInstructor.dart';
import 'package:testeur/presentation/ressources/colors_manager.dart';
import 'package:testeur/presentation/setting/settingview.dart';
import 'package:testeur/presentation/instructor/bloc/instructor_bloc.dart';
import 'package:testeur/presentation/instructor/bloc/instructor_state.dart';
import 'package:testeur/presentation/instructor/viewmodel/instructor_viewmodel.dart';
import 'package:testeur/domain/model/logged_user.dart';
import 'package:testeur/domain/model/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../course/bloc/course_bloc.dart';
import '../course/bloc/course_state.dart';
import '../course/viewmodel/course_viewmodel.dart';
import '../ressources/assets_manager.dart';

class InstructorCourses extends StatefulWidget {
  final String instructorId;

  const InstructorCourses({super.key, required this.instructorId});

  @override
  State<InstructorCourses> createState() => _InstructorCoursesState();
}

class _InstructorCoursesState extends State<InstructorCourses> {
  late InstructorViewmodel _instructorViewModel;
  late CourseViewmodel courseViewModel;
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  LoggedUser? _loggedUser;

  @override
  void initState() {
    super.initState();
    final instructorBloc = context.read<InstructorBloc>();
    _instructorViewModel = InstructorViewmodel(instructorBloc);
    _instructorViewModel.getCoursesByInstructors(int.parse(widget.instructorId), 0, 10);
    courseViewModel = CourseViewmodel(context.read<CourseBloc>());
    courseViewModel.searchCourses('', 0, 10);
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
    _instructorViewModel.instructorBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0 ? const Text('Courses') : null,
        actions: _currentIndex == 0
            ? [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_loggedUser != null) {
                showDialog(
                  context: context,
                  builder: (context) => CourseModalInstructor(
                    loggedUser: _loggedUser!,
                  ),
                );
              }
            },
          ),
        ]
            : null,
        bottom: _currentIndex == 0 ? _buildSearchBar() : null,
      ),
      body: BlocListener<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseSuccessSave || state is CourseSuccessUpdate) {
            _instructorViewModel.getCoursesByInstructors(int.parse(widget.instructorId), 0, 10);
          } else if (state is CourseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: _currentIndex == 0 ? _buildCoursesView() : _buildProfileView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              _instructorViewModel.getCoursesByInstructors(int.parse(widget.instructorId), 0, 10);
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Search courses...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: ImageIcon(AssetImage(IconAssets.search)),
              onPressed: () {
                courseViewModel.searchCourses(_searchController.text, 0, 10);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesView() {
    return BlocBuilder<InstructorBloc, InstructorState>(
      bloc: _instructorViewModel.instructorBloc,
      builder: (context, state) {
        if (state is InstructorLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CoursesByInstructorSuccessState) {
          if (state.courses.isEmpty) {
            return const Center(child: Text('No courses available at the moment'));
          }
          return _buildCoursesList(state.courses);
        } else if (state is InstructorErrorState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: CircularProgressIndicator());
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

  Widget _buildCoursesList(List<Course> courses) {
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
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCardInstructor(
            courseName: course.courseName,
            courseDuration: course.courseDuration,
            courseDescription: course.courseDescription,
            instructorName: '${course.instructor!.firstName} ${course.instructor!.lastName}',
            instructorSummary: course.instructor!.summary,
            course: course,
          );
        },
      ),
    );
  }
}