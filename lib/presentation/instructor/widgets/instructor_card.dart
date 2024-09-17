import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/value_manager.dart';
import '../../../domain/model/course.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/routes_manager.dart';
import '../bloc/instructor_bloc.dart';
import '../../../domain/model/instructor.dart';
import '../bloc/instructor_state.dart';
import '../viewmodel/instructor_viewmodel.dart';

class InstructorCard extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String summary;
  final Instructor instructor;

  const InstructorCard({
    required this.firstName,
    required this.lastName,
    required this.summary,
    required this.instructor,
    Key? key,
  }) : super(key: key);

  @override
  State<InstructorCard> createState() => _InstructorCardState();
}

class _InstructorCardState extends State<InstructorCard> {
  late InstructorViewmodel instructorViewModel;

  @override
  void initState() {
    super.initState();
    instructorViewModel = InstructorViewmodel(context.read<InstructorBloc>());
  }

  void _showCoursesModal(BuildContext context) {
    instructorViewModel.getCoursesByInstructor(widget.instructor.instructorId, 0, 10);

    showDialog(
      context: context,
      builder: (context) {
        return BlocListener<InstructorBloc, InstructorState>(
          listener: (context, state) {
            if (state is GetCoursesByInstructorSuccessState) {
              Navigator.of(context).pop(); // Close the loading dialog
              _showCoursesDialog(context, state.courses);
            } else if (state is InstructorErrorState) {
              Navigator.of(context).pop(); // Close the loading dialog
              _showErrorDialog(context, state.message);
            }
          },
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _showCoursesDialog(BuildContext context, List<Course> courses) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Courses'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.courseName),
                  subtitle: Text(course.courseDescription),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //recharger page mainRoute à l'indice 2
                Navigator.pushReplacementNamed(context, Routes.mainRoute);



              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error: $message'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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
                '${widget.firstName} ${widget.lastName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Summary: ${widget.summary}',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.darkGrey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Instructor'),
                          content: const Text('Are you sure you want to delete this instructor?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                instructorViewModel.deleteInstructor(widget.instructor.instructorId);
                                Navigator.of(context).pop();
                                Navigator.pushReplacementNamed(context, Routes.mainRoute);

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _showCoursesModal(context);
                    },
                    child: const Text('View Courses'),
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