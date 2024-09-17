import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../domain/model/course.dart';
import '../../../domain/model/logged_user.dart';
import '../../course/bloc/course_bloc.dart';
import '../../course/viewmodel/course_viewmodel.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/value_manager.dart';
import '../../student/bloc/student_bloc.dart';
import '../../student/viewmodel/student-viewmodel.dart';

class CourseCardStudent extends StatefulWidget {
  final String courseName;
  final String courseDuration;
  final String courseDescription;
  final String instructorName;
  final String instructorSummary;
  final Course course;
  final bool isEnrolled;

  const CourseCardStudent({
    required this.courseName,
    required this.courseDuration,
    required this.courseDescription,
    required this.instructorName,
    required this.instructorSummary,
    required this.course,
    required this.isEnrolled,
    Key? key,
  }) : super(key: key);

  @override
  State<CourseCardStudent> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCardStudent> {
  late CourseViewmodel courseViewModel;
  late Studentviewmodel studentViewModel;
  LoggedUser? _loggedUser;

  @override
  void initState() {
    super.initState();
    courseViewModel = CourseViewmodel(context.read<CourseBloc>());
    studentViewModel = Studentviewmodel(context.read<StudentBloc>());
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

  void enrollStudentInCourse(int courseId) {
    if (_loggedUser != null) {
      try {
        studentViewModel.enrollStudentInCourse(courseId, _loggedUser!.student!.studentId);
        _showEnrollmentSuccessPopup();
      } catch (e) {
        print('Error enrolling student in course: $e');
        _showEnrollmentErrorPopup();
      }
    } else {
      print('Logged user not available');
    }
  }

  void _showEnrollmentSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enrollment Successful'),
          content: const Text('You have successfully enrolled in the course.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEnrollmentErrorPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enrollment Failed'),
          content: const Text('There was an error enrolling in the course. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              if (!widget.isEnrolled)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          enrollStudentInCourse(widget.course.courseId);
                        },
                        child: const Text('Enroll'),
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