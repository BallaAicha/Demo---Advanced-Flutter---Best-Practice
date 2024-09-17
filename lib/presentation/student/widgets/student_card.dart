import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/value_manager.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/routes_manager.dart';
import '../bloc/student_bloc.dart';

import '../../../domain/model/student.dart';
import '../viewmodel/student-viewmodel.dart';

class StudentCard extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String level;
  final Student student;

  const StudentCard({
    required this.firstName,
    required this.lastName,
    required this.level,
    required this.student,
    Key? key,
  }) : super(key: key);

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  late Studentviewmodel studentViewModel;

  @override
  void initState() {
    super.initState();
    studentViewModel = Studentviewmodel(context.read<StudentBloc>());
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
                'Level: ${widget.level}',
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
                          title: const Text('Delete Student'),
                          content: const Text('Are you sure you want to delete this student?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                               studentViewModel.deleteStudent(widget.student.studentId);
                                Navigator.of(context).pop();
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text('Student deleted successfully')),
                               );
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

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}