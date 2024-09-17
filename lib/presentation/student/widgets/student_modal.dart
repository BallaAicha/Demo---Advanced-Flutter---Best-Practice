import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/ressources/routes_manager.dart';
import '../../ressources/colors_manager.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_state.dart';
import '../../../domain/model/student.dart';
import '../../../domain/model/user.dart';
import '../viewmodel/student-viewmodel.dart';


class StudentModal extends StatefulWidget {
  const StudentModal({Key? key}) : super(key: key);

  @override
  State<StudentModal> createState() => _StudentModalState();
}

class _StudentModalState extends State<StudentModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailUnique = true;

  @override
  Widget build(BuildContext context) {
    final studentViewModel = Studentviewmodel(context.read<StudentBloc>());

    return BlocListener<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is StudentSavedSuccessState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student saved successfully!')),
          );
          Navigator.of(context).pushNamed(Routes.studentRoute);
        } else if (state is StudentErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save student: ${state.message}')),
          );
        } else if (state is EmailExistSuccessState) {
          setState(() {
            _isEmailUnique = !state.isExist;//signifie que l'email n'existe pas
          });
        }
      },
      child: AlertDialog(
        title: const Text('Add New Student'),
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
                  controller: _levelController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Level',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter level',
                    hintStyle: const TextStyle(color: Colors.black),
                    errorStyle: TextStyle(color: ColorManager.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the level';
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
                      studentViewModel.checkIfEmailExist(value);
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
                final student = Student(
                  studentId: 0,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  level: _levelController.text,
                  user: user,
                );
                studentViewModel.saveStudent(student);
              }
            },
            child: const Text('Add Student'),
          ),
        ],
      ),
    );
  }
}