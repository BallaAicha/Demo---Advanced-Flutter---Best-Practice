import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/instructor/viewmodel/instructor_viewmodel.dart';
import 'package:testeur/presentation/instructor/widgets/instructor_card.dart';
import 'package:testeur/presentation/instructor/widgets/instructor_modal.dart';

import '../ressources/assets_manager.dart';
import '../ressources/colors_manager.dart';
import 'bloc/instructor_bloc.dart';
import 'bloc/instructor_state.dart';

class InstructorView extends StatefulWidget {
  const InstructorView({super.key});

  @override
  State<InstructorView> createState() => _InstructorViewState();
}

class _InstructorViewState extends State<InstructorView> {
  late InstructorViewmodel instructorViewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    instructorViewModel = InstructorViewmodel(context.read<InstructorBloc>());
    instructorViewModel.searchInstructors('', 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const InstructorModal(),
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
                      hintStyle: const TextStyle(color: Colors.black),
                      hintText: 'Search instructors...',
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
                  icon: const ImageIcon(AssetImage(IconAssets.search)),
                  onPressed: () {
                    instructorViewModel.searchInstructors(_searchController.text, 0, 10);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocListener<InstructorBloc, InstructorState>(
        listener: (context, state) {
          if (state is InstructorErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Container(
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
          child: BlocBuilder<InstructorBloc, InstructorState>(
            builder: (context, state) {
              if (state is InstructorInitialState) {
                return const Center(child: Text('Please start a search.'));
              } else if (state is InstructorLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchInstructorsSuccessState) {
                if (state.instructors.isEmpty) {
                  return Center(
                    child: Text(
                      'No Instructors found.',
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorManager.primary,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.instructors.length,
                  itemBuilder: (context, index) {
                    final instructor = state.instructors[index];
                    return InstructorCard(
                      firstName: instructor.firstName,
                      lastName: instructor.lastName,
                      summary: instructor.summary,
                      instructor: instructor,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}