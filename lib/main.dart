import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/domain/usecases/student_usecase.dart';
import 'package:testeur/presentation/login/bloc/auth_bloc.dart';
import 'package:testeur/presentation/login/login.dart';
import 'package:dio/dio.dart';
import 'package:testeur/data/datasource/auth_data_source.dart';
import 'package:testeur/data/repository/auth_repository_impl.dart';
import 'package:testeur/domain/usecases/login_use_case.dart';
import 'package:testeur/data/factory/dio_factory.dart';
import 'package:testeur/app/manager/token_manager.dart';
import 'package:testeur/data/datasource/course_data_source.dart';
import 'package:testeur/domain/usecases/course_use_cases.dart';
import 'package:testeur/presentation/course/bloc/course_bloc.dart';
import 'package:testeur/presentation/ressources/routes_manager.dart';
import 'package:testeur/presentation/ressources/theme_manager.dart';
import 'package:testeur/presentation/instructor/bloc/instructor_bloc.dart';
import 'package:testeur/domain/usecases/instructor_usecase.dart';
import 'package:testeur/presentation/student/bloc/student_bloc.dart';

import 'data/datasource/admin_instructor_data_source.dart';
import 'data/datasource/admin_student_data_source.dart';
import 'data/datasource/instructor_data_source.dart';
import 'data/datasource/student_data_source.dart';
import 'data/repository/admin_instructor_repository.dart';
import 'data/repository/admin_student_repository.dart';
import 'data/repository/course_repository_impl.dart';
import 'data/repository/instructor_repository_impl.dart';
import 'data/repository/student_repository.dart';
import 'domain/repository/admin_student_repository.dart';
import 'domain/usecases/admin_instructor_usecase.dart';
import 'domain/usecases/admin_student_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenManager = TokenManager();
  await tokenManager.clearTokens();
  final dioFactory = DioFactory(tokenManager);
  final dio = await dioFactory.createDio();
  final navigatorKey = GlobalKey<NavigatorState>();

  final authDataSource = AuthDataSource(dio, tokenManager, navigatorKey);
  final courseDataSource = CourseDataSource(dio, tokenManager);
  final authRepository = AuthRepositoryImpl(authDataSource);
  final loginUseCase = LoginUseCase(authRepository);
  final courseRepository = CourseRepositoryImpl(courseDataSource);
  final courseUseCases = CourseUseCases(courseRepository);
  final InstructorDataSource instructorDataSource = InstructorDataSource(dio, tokenManager);
  final instructorRepository = InstructorRepositoryImpl(instructorDataSource);
  final instructorUseCases = InstructorUseCases(instructorRepository);
  //pour student
  final studentDataSource = StudentDataSource(dio, tokenManager);
  final studentRepository = StudentRepositoryImpl(studentDataSource);
  final studentUseCase = StudentUsecase(studentRepository);
  //pour admin
  final adminStudentDataSource = AdminStudentDataSource(dio, tokenManager);
  final studentRepositoryadmin = AdminStudentRepositoryImpl(adminStudentDataSource);
  final adminStudentUsecase = AdminStudentUsecase(studentRepositoryadmin);

  final adminInstructorDataSource = AdminInstructorDataSource(dio, tokenManager);
  final adminInstructorRepository = AdminInstructorRepositoryImpl(adminInstructorDataSource);
  final adminInstructorUsecase = AdminInstructorUsecase(adminInstructorRepository);



  runApp(MyApp(
    loginUseCase: loginUseCase,
    courseUseCases: courseUseCases,
    instructorUseCases: instructorUseCases,
    studentUseCase: studentUseCase,
    adminStudentUsecase: adminStudentUsecase,
    adminInstructorUsecase: adminInstructorUsecase,



    navigatorKey: navigatorKey,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final CourseUseCases courseUseCases;
  final InstructorUseCases instructorUseCases;
  final GlobalKey<NavigatorState> navigatorKey;
  final StudentUsecase studentUseCase;
  final AdminStudentUsecase? adminStudentUsecase;
  final AdminInstructorUsecase? adminInstructorUsecase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.courseUseCases,
    required this.instructorUseCases,
    required this.navigatorKey,
    required this.studentUseCase,
    this.adminStudentUsecase,
    this.adminInstructorUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(loginUseCase),
        ),
        BlocProvider(
          create: (_) => CourseBloc(courseUseCases),
        ),
        BlocProvider(
          create: (_) => InstructorBloc(instructorUseCases, adminInstructorUsecase),
        ),
        BlocProvider(
          create: (_) => StudentBloc(studentUseCase,adminStudentUsecase),
        ),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.loginRoute,
        theme: getApplicationTheme(),
        navigatorKey: navigatorKey,
        home: LoginPage(),
      ),
    );
  }
}