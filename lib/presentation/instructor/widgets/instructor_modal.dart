import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/domain/model/instructor.dart';
import 'package:testeur/presentation/instructor/bloc/instructor_bloc.dart';

import '../../../domain/model/user.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/routes_manager.dart';

import '../bloc/instructor_state.dart';
import '../viewmodel/instructor_viewmodel.dart';

class InstructorModal extends StatefulWidget {
  const InstructorModal({super.key});

  @override
  State<InstructorModal> createState() => _InstructorModalState();
}

class _InstructorModalState extends State<InstructorModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailUnique = true;
  @override
  Widget build(BuildContext context) {
    final instructorViewModel = InstructorViewmodel(context.read<InstructorBloc>());
    return BlocListener<InstructorBloc, InstructorState>(
      listener: (context, state) {
        if (state is SaveInstructorSuccessState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Instructor saved successfully!')),
          );
          Navigator.of(context).pushNamed(Routes.instructorRoute);
        } else if (state is InstructorErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save instructor: ${state.message}')),
          );
        } else if (state is EmailExistSuccessState) {
          setState(() {
            _isEmailUnique = !state.isExist;
          });
        }
      },
      child: AlertDialog(
        title: const Text('Add Instructor'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter first name',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: TextStyle(color: ColorManager.primary),
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
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter last name',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: TextStyle(color: ColorManager.primary),
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
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Summary',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter summary',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: TextStyle(color: ColorManager.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the summary';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter email',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: TextStyle(color: ColorManager.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    if (!RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    if (!_isEmailUnique) {
                      return 'Email already exists';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$').hasMatch(value)) {
                      instructorViewModel.checkIfEmailExist(value);
                    }
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter password',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: TextStyle(color: ColorManager.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the password';
                    }
                    return null;
                  },
                  obscureText: true,
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
                final user = User(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                final instructor = Instructor(
                  instructorId: 0,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  summary: _summaryController.text,
                  user: user,
                );
                instructorViewModel.saveInstructor(instructor);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
