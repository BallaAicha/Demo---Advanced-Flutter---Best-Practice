import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/colors_manager.dart';
import 'package:testeur/presentation/instructor/viewmodel/instructor_viewmodel.dart';
import 'package:testeur/domain/model/logged_user.dart';
import 'package:testeur/presentation/setting/widgets/profile_header.dart';
import '../../../domain/model/instructor.dart';
import '../../instructor/bloc/instructor_bloc.dart';
import '../../instructor/bloc/instructor_state.dart';
import '../../instructor/bloc/instructor_event.dart';

class InstructorModale extends StatefulWidget {
  final Instructor? instructor;
  final LoggedUser loggedUser;

  const InstructorModale({Key? key, this.instructor, required this.loggedUser}) : super(key: key);

  @override
  State<InstructorModale> createState() => _InstructorModalState();
}

class _InstructorModalState extends State<InstructorModale> {
  late InstructorViewmodel _instructorViewModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _instructorViewModel = InstructorViewmodel(
      context.read<InstructorBloc>(),
    ); // Initialize the view model
    if (widget.instructor != null) {
      _firstNameController.text = widget.instructor!.firstName;
      _lastNameController.text = widget.instructor!.lastName;
      _summaryController.text = widget.instructor!.summary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorBloc, InstructorState>(
      listener: (context, state) {
        if (state is InstructorUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Instructor updated successfully')),
          );

          // Update text controllers with new values
          setState(() {
            _firstNameController.text = state.instructor.firstName;
            _lastNameController.text = state.instructor.lastName;
            _summaryController.text = state.instructor.summary;

            // Reinstantiate LoggedUser with new values
            widget.loggedUser.instructor = state.instructor;
          });

          Navigator.of(context).pop();

          // Emit an event to reload data
          context.read<InstructorBloc>().add(GetCoursesByInstructor(int.parse(widget.instructor!.instructorId.toString()), 0, 10));
        } else if (state is InstructorErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: Text('Edit Instructor'),
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
                    controller: _summaryController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: ColorManager.primary),
                      labelText: 'Summary',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the summary';
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
                  final instructor = Instructor(
                    instructorId: widget.instructor?.instructorId ?? 0,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    summary: _summaryController.text,
                  );
                  // Call the update method
                  _instructorViewModel.updateInstructor(instructor);
                }
              },
              child: state is InstructorLoadingState
                  ? const CircularProgressIndicator()
                  : const Text('Update Instructor'),
            ),
          ],
        );
      },
    );
  }
}