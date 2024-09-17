import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/course/viewmodel/course_viewmodel.dart';
import 'package:testeur/presentation/course/widgets/course_card.dart';
import 'package:testeur/presentation/course/widgets/course_modal.dart';
import '../ressources/assets_manager.dart';
import '../ressources/colors_manager.dart';
import 'bloc/course_bloc.dart';
import 'bloc/course_state.dart';

class Courseview extends StatefulWidget {
  const Courseview({super.key});

  @override
  _CourseviewState createState() => _CourseviewState();
}

class _CourseviewState extends State<Courseview> {
  late CourseViewmodel courseViewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    courseViewModel = CourseViewmodel(context.read<CourseBloc>());
    courseViewModel.searchCourses('', 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CourseModal(),
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
                Expanded(child: TextFormField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: 'Search courses...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,



                    ),


                    filled: true,
                    fillColor: Colors.white,
                  ),

                ),),
                IconButton(
                  icon: ImageIcon(AssetImage(IconAssets.search)),
                  onPressed: () {
                    courseViewModel.searchCourses(_searchController.text, 0, 10);
                  },
                ),
              ],
            )
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
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseSuccess) {
              return ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  return CourseCard(
                    courseName: course.courseName,
                    courseDuration: course.courseDuration,
                    courseDescription: course.courseDescription,
                    instructorName: '${course.instructor!.firstName} ${course.instructor!.lastName}',
                    instructorSummary: course.instructor!.summary,
                    course: course, // Pass the course parameter here
                  );
                },
              );
            } else if (state is CourseError) {
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