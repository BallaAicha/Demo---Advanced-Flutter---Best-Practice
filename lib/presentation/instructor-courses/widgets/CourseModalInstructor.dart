import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/routes_manager.dart';

import '../../../domain/model/course.dart';
import '../../../domain/model/instructor.dart';
import '../../../domain/model/logged_user.dart';
import '../../course/bloc/course_bloc.dart';
import '../../course/bloc/course_state.dart';
import '../../course/viewmodel/course_viewmodel.dart';

class CourseModalInstructor extends StatefulWidget {
  final Course? course;
  final LoggedUser loggedUser;

  const CourseModalInstructor({Key? key, this.course, required this.loggedUser}) : super(key: key);

  @override
  State<CourseModalInstructor> createState() => _CourseModalInstructorState();
}

class _CourseModalInstructorState extends State<CourseModalInstructor> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDurationController = TextEditingController();
  final TextEditingController _courseDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _courseNameController.text = widget.course!.courseName;
      _courseDurationController.text = widget.course!.courseDuration;
      _courseDescriptionController.text = widget.course!.courseDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseViewModel = CourseViewmodel(context.read<CourseBloc>());

    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CourseSuccessSave) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course saved successfully!')),
          );

        } else if (state is CourseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save course: ${state.message}')),
          );
        } else if (state is CourseSuccessUpdate) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course updated successfully!')),
          );

        } else if (state is CourseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update course: ${state.message}')),
          );
        }
      },
      child: AlertDialog(
        title: Text(widget.course == null ? 'Add New Course' : 'Edit Course'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _courseNameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Course Name',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Enter course name',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _courseDurationController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Course Duration',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Enter course duration',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course duration';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _courseDescriptionController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Course Description',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Enter course description',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the course description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final course = Course(
                  courseId: widget.course?.courseId ?? 0,
                  courseName: _courseNameController.text,
                  courseDuration: _courseDurationController.text,
                  courseDescription: _courseDescriptionController.text,
                  instructor: widget.loggedUser.instructor!,
                );
                if (widget.course == null) {
                  courseViewModel.saveCourse(course);
                } else {
                  courseViewModel.updateCourse(course);
                }
              }
            },
            child: Text(widget.course == null ? 'Add Course' : 'Update Course'),
          ),
        ],
      ),
    );
  }
}