import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/student/viewmodel/student-viewmodel.dart';
import 'package:testeur/presentation/student/widgets/student_card.dart';
import 'package:testeur/presentation/student/widgets/student_modal.dart';

import '../course/widgets/course_modal.dart';
import '../ressources/assets_manager.dart';
import '../ressources/colors_manager.dart';
import 'bloc/student_bloc.dart';
import 'bloc/student_state.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  late Studentviewmodel studentViewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    studentViewModel = Studentviewmodel(context.read<StudentBloc>());
    studentViewModel.searchStudents('', 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add student functionality
              showDialog(
                context: context,
                builder: (context) => const StudentModal(),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black),
                      hintText: 'Search students...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: ImageIcon(AssetImage(IconAssets.search)),
                  onPressed: () {
                    studentViewModel.searchStudents(_searchController.text, 0, 10);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
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
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentsSearchSuccessState) {
              if (state.students.isEmpty) {
                return  Center(child: Text('No students found.', style: TextStyle(
                  fontSize: 20,
                    color: ColorManager.primary),));
              }
              return ListView.builder(
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  final student = state.students[index];
                  return StudentCard(
                    firstName: student.firstName,
                    lastName: student.lastName,
                    level: student.level,
                    student: student,
                  );
                },
              );
            } else if (state is StudentErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}