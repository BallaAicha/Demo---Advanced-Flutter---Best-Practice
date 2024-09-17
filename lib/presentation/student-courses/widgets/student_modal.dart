import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/colors_manager.dart';
import 'package:testeur/presentation/student/viewmodel/student-viewmodel.dart';
import 'package:testeur/domain/model/logged_user.dart';
import 'package:testeur/presentation/setting/widgets/profile_header.dart';
import '../../../domain/model/student.dart';
import '../../student/bloc/student_bloc.dart';
import '../../student/bloc/student_state.dart';
import '../../student/bloc/student_event.dart';

class StudentModal extends StatefulWidget {
  final Student? student;
  final LoggedUser loggedUser;

  const StudentModal({Key? key, this.student, required this.loggedUser}) : super(key: key);

  @override
  State<StudentModal> createState() => _StudentModalState();
}

class _StudentModalState extends State<StudentModal> {
  late Studentviewmodel _studentViewModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentViewModel = Studentviewmodel(
      context.read<StudentBloc>(),
    ); // Initialize the view model
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _levelController.text = widget.student!.level;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is StudentUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student updated successfully')),
          );

          // Mettre à jour les contrôleurs de texte avec les nouvelles valeurs
          setState(() {
            _firstNameController.text = state.student.firstName;
            _lastNameController.text = state.student.lastName;
            _levelController.text = state.student.level;

            // Réinstancier LoggedUser avec les nouvelles valeurs
            widget.loggedUser.student = state.student;
          });

          Navigator.of(context).pop();

          // Émettre un événement pour recharger les données
          context.read<StudentBloc>().add(FetchCoursesByStudentEvent(widget.student!.studentId.toString(), 0, 10));
        } else if (state is StudentErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text('Edit Student'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(loggedUser: widget.loggedUser),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorManager.primary),
                      labelText: 'First Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorManager.primary),
                      labelText: 'Last Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _levelController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorManager.primary),
                      labelText: 'Level',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the level';
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
                  final student = Student(
                    studentId: widget.student?.studentId ?? 0,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    level: _levelController.text,
                  );
                  // Call the update method
                  _studentViewModel.updateStudent(student);
                }
              },
              child: state is StudentLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update Student'),
            ),
          ],
        );
      },
    );
  }
}