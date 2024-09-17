import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../domain/model/course.dart';
import '../../../domain/model/logged_user.dart';
import '../../course/bloc/course_bloc.dart';
import '../../course/viewmodel/course_viewmodel.dart';
import '../../instructor-courses/widgets/CourseModalInstructor.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/value_manager.dart';
import '../bloc/instructor_bloc.dart';
import '../bloc/instructor_event.dart';

class CourseCardInstructor extends StatefulWidget {
  final String courseName;
  final String courseDuration;
  final String courseDescription;
  final String instructorName;
  final String instructorSummary;
  final Course course;

  const CourseCardInstructor({
    required this.courseName,
    required this.courseDuration,
    required this.courseDescription,
    required this.instructorName,
    required this.instructorSummary,
    required this.course,
    Key? key,
  }) : super(key: key);

  @override
  State<CourseCardInstructor> createState() => _CourseCardInstructorState();
}

class _CourseCardInstructorState extends State<CourseCardInstructor> {
  late CourseViewmodel courseViewModel;
  LoggedUser? _loggedUser;

  @override
  void initState() {
    super.initState();
    courseViewModel = CourseViewmodel(context.read<CourseBloc>());
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

  void updateCourse(int courseId) {
    // Implement course update logic here
  }

  @override
  Widget build(BuildContext context) {
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
      child: Card(
        margin: const EdgeInsets.all(AppPadding.p14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.courseName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Duration: ${widget.courseDuration}',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.courseDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.grey,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instructor: ${widget.instructorName}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.instructorSummary,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CourseModalInstructor(
                            course: widget.course,
                            loggedUser: _loggedUser!,
                          ),
                        ).then((_) {
                          // Reload courses after update
                          context.read<InstructorBloc>().add(GetCoursesByInstructorEvent(widget.course.instructor!.instructorId, 0, 10));
                        });
                      },
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}