import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/value_manager.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/routes_manager.dart';
import '../bloc/course_bloc.dart';
import '../viewmodel/course_viewmodel.dart';
import 'course_modal.dart';
import '../../../domain/model/course.dart';


class CourseCard extends StatefulWidget {
  final String courseName;
  final String courseDuration;
  final String courseDescription;
  final String instructorName;
  final String instructorSummary;
  final Course course;

  const CourseCard({
    required this.courseName,
    required this.courseDuration,
    required this.courseDescription,
    required this.instructorName,
    required this.instructorSummary,
    required this.course,
    Key? key,
  }) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late CourseViewmodel courseViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseViewModel = CourseViewmodel(context.read<CourseBloc>());

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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Course'),
                          content: const Text('Are you sure you want to delete this course?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                courseViewModel.deleteCourse(widget.course.courseId);
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(Routes.mainRoute);
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
                      showDialog(
                        context: context,
                        builder: (context) => CourseModal(course: widget.course),
                      );
                    },
                    child: const Text('Edit'),
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