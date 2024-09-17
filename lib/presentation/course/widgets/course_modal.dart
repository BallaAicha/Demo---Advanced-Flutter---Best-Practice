import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/routes_manager.dart';
import '../../instructor/bloc/instructor_bloc.dart';
import '../../instructor/bloc/instructor_state.dart';
import '../../instructor/viewmodel/instructor_viewmodel.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_state.dart';
import '../viewmodel/course_viewmodel.dart';
import '../../../domain/model/course.dart';
import '../../../domain/model/instructor.dart';
class CourseModal extends StatefulWidget {
  final Course? course;
  const CourseModal({Key? key, this.course}) : super(key: key);

  @override
  State<CourseModal> createState() => _CourseModalState();
}

class _CourseModalState extends State<CourseModal> {
  late InstructorViewmodel instructorViewModel;
  List<Instructor> instructors = [];
  Instructor? selectedInstructor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDurationController = TextEditingController();
  final TextEditingController _courseDescriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    instructorViewModel = InstructorViewmodel(context.read<InstructorBloc>());
    instructorViewModel.fetchInstructors();
    if (widget.course != null) {
      _courseNameController.text = widget.course!.courseName;
      _courseDurationController.text = widget.course!.courseDuration;
      _courseDescriptionController.text = widget.course!.courseDescription;
      selectedInstructor = widget.course!.instructor;
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
          Navigator.of(context).pushNamed(Routes.mainRoute);
        } else if (state is CourseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save course: ${state.message}')),
          );
        }
        else if (state is CourseSuccessUpdate) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course updated successfully!')),
          );
          Navigator.of(context).pushNamed(Routes.mainRoute);
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
                BlocBuilder<InstructorBloc, InstructorState>(
                  builder: (context, state) {
                    if (state is InstructorLoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is InstructorSuccessState) {
                      instructors = state.instructors.cast<Instructor>();
                      if (widget.course != null && selectedInstructor != null) {
                        if (!instructors.contains(selectedInstructor)) {
                          selectedInstructor = instructors.first;// Si l'instructeur actuel n'est pas présent dans la liste, sélectionnez le premier instructeur
                        } else {
                          selectedInstructor = instructors.firstWhere(// Vérifiez si l'instructeur actuel est présent dans la liste
                                (instructor) => instructor.instructorId == selectedInstructor!.instructorId,
                            orElse: () => instructors.first,
                          );
                        }
                      }

                      return DropdownButtonFormField<Instructor>(
                        value: selectedInstructor ?? (widget.course != null ? widget.course!.instructor : null),
                        items: instructors.map((Instructor instructor) {
                          return DropdownMenuItem<Instructor>(
                            value: instructor,
                            child: Text('${instructor.firstName} ${instructor.lastName}'),
                          );
                        }).toList(),
                        onChanged: (Instructor? newValue) {
                          setState(() {
                            selectedInstructor = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Instructor',
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: 'Choose an instructor',
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an instructor';
                          }
                          return null;
                        },
                      );
                    } else {
                      return const Text('Error loading instructors');
                    }
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
                  instructor: selectedInstructor!,
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